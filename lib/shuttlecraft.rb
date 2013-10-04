require 'rinda/ring'

class Shuttlecraft

  PROVIDER_TEMPLATE = [:name, :Mothership, nil, nil]
  REGISTRATION_TEMPLATE = [:name, nil, nil]

  attr_accessor :ring_server, :mothership, :name

  def initialize(name='foo')
    @drb = DRb.start_service
    puts "Starting DRb Service on #{@drb.uri}"

    @ring_server = Rinda::RingFinger.primary
    @name = name
  end

  def find_all_motherships
    ring_server.read_all(Shuttlecraft::PROVIDER_TEMPLATE).collect{|_,_,m,name| [name, m]}
  end

  def initiate_communication_with(name=nil)
    motherships = find_all_motherships

    if name
      @mothership = motherships.detect{|m| m[0] == name}
    else
      @mothership = motherships.first
    end

    @mothership = Rinda::TupleSpaceProxy.new @mothership[1] if @mothership
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
  s.register

  sleep(5)

  s.unregister
end
