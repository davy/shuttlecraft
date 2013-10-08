require 'rinda/ring'

class Shuttlecraft

  VERSION = '0.0.1'

  # [:name, :Mothership, name, Rinda::TupleSpace:tuplespace]
  PROVIDER_TEMPLATE = [:name, :Mothership, String, nil]

  # [:name, name, drb_uri]
  REGISTRATION_TEMPLATE = [:name, String, String]

  attr_accessor :ring_server, :mothership, :name, :protocol

  def initialize(opts={})
    @drb = DRb.start_service(nil, self)
    puts "Starting DRb Service on #{@drb.uri}"

    @name = opts[:name] || self.default_name
    @protocol = opts[:protocol] || Shuttlecraft::Protocol.default

    @ring_server = Rinda::RingFinger.primary
    @receive_loop = nil
  end

  def self.default_name
    'Shuttlecraft'
  end

  def provider_template
    temp = PROVIDER_TEMPLATE.dup
    temp[1] = @protocol.service_name
    temp
  end

  def find_all_motherships
    ring_server.read_all(provider_template).collect{|_,_,name,ts| {name: name, ts: ts}}
  end

  def initiate_communication_with_mothership(name=nil)
    motherships = find_all_motherships

    if name
      provider = motherships.detect{|m| m[:name] == name}
    else
      provider = motherships.first
    end

    if provider
      @mothership = Rinda::TupleSpaceProxy.new provider[:ts]
    end
  end

  # duplicated from mothership
  def registered_services
    @mothership.read_all(Shuttlecraft::REGISTRATION_TEMPLATE).collect{|_,name,uri| [name,uri]}
  end

  def register
    unless @mothership.nil? || registered?
      @mothership.write([:name, @name, DRb.uri])
    end
  end

  def registered?
    return false unless @mothership

    !@mothership.read_all(Shuttlecraft::REGISTRATION_TEMPLATE).detect{|t| t[1] == @name && t[2] == DRb.uri}.nil?
  end

  def unregister
    if registered?
      @mothership.take([:name, @name, DRb.uri])
    end
  end
end

require 'shuttlecraft/mothership'
require 'shuttlecraft/protocol'
require 'shuttlecraft/mothership_app'
require 'shuttlecraft/shuttlecraft_app'

if __FILE__ == $0
  s = Shuttlecraft.new
  s.initate_communication_with_mothership
  s.register

  sleep(5)

  s.unregister
end
