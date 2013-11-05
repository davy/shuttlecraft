require 'rinda/ring'

require 'shuttlecraft/comms'

class Shuttlecraft

  include Shuttlecraft::Comms

  VERSION = '0.0.1'

  # [:name, :Mothership, name, Rinda::TupleSpace:tuplespace]
  PROVIDER_TEMPLATE = [:name, :Mothership, String, nil]

  # [:name, name, drb_uri]
  REGISTRATION_TEMPLATE = [:name, String, String]

  attr_accessor :ring_server, :mothership, :name, :protocol

  def initialize(opts={})
    initialize_comms(opts)

    @drb = DRb.start_service(nil, self)

    @name = opts[:name] || self.default_name
    @protocol = opts[:protocol] || Shuttlecraft::Protocol.default
    @verbose = opts[:verbose] || false

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

  def register
    update!
    unless @mothership.nil? || registered?
      begin
        @mothership.write([:name, @name, DRb.uri])
      rescue DRb::DRbConnError
        # mothership went away =(
      end
    end
  end

  def registered?
    update!
    return false unless @mothership

    !registered_services.detect{|t| !t.nil? && t[0] == @name && t[1] == DRb.uri}.nil?
  end

  def unregister
    update!
    if registered?
      begin
        @mothership.take([:name, @name, DRb.uri])
      rescue DRb::DRbConnError
        # mothership went away =(
      end
    end
  end

  private

  ##
  # For Shuttlecraft::Comms
  def tuplespace
    @mothership
  end
end

require 'shuttlecraft/mothership'
require 'shuttlecraft/protocol'
require 'shuttlecraft/resolv'
require 'shuttlecraft/mothership_app'
require 'shuttlecraft/shuttlecraft_app'

if __FILE__ == $0
  s = Shuttlecraft.new
  s.initate_communication_with_mothership
  s.register

  sleep(5)

  s.unregister
end
