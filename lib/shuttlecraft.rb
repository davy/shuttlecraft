require 'rinda/ring'

class Shuttlecraft

  # [:name, :Mothership, name, Rinda::TupleSpace:tuplespace]
  PROVIDER_TEMPLATE = [:name, :Mothership, String, nil]

  # [:name, name, drb_uri]
  REGISTRATION_TEMPLATE = [:name, String, String]

  attr_accessor :ring_server, :mothership, :name

  def initialize(name='Shuttlecraft')
    @drb = DRb.start_service
    puts "Starting DRb Service on #{@drb.uri}"

    @ring_server = Rinda::RingFinger.primary
    @name = name
  end

  def find_all_motherships
    ring_server.read_all(Shuttlecraft::PROVIDER_TEMPLATE).collect{|_,_,name,ts| {name: name, ts: ts}}
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

  def send_message(msg)
    @mothership.write([msg])
  end
end

if __FILE__ == $0
  s = Shuttlecraft.new
  s.initate_communication_with_mothership
  s.register

  sleep(5)

  s.unregister
end
