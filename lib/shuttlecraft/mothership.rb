require 'rinda/ring'
require 'rinda/tuplespace'

class Shuttlecraft::Mothership

  attr_reader :ts, :provider, :name, :protocol

  def initialize(opts={})
    @drb = DRb.start_service
    puts "Starting DRb Service on #{@drb.uri}"

    @protocol = opts[:protocol] || Shuttlecraft::Protocol.default
    @name = opts[:name] || @protocol.name

    @ts = Rinda::TupleSpace.new

    @provider = Rinda::RingProvider.new(@protocol.service_name, @name, @ts)
    @provider.provide

    notify_on_registration
    notify_on_unregistration
    notify_on_write
  end

  def registered_services
    @ts.read_all(Shuttlecraft::REGISTRATION_TEMPLATE).collect{|_,name,uri| [name,uri]}
  end

  def notify_on_registration
    @registration_observer = @ts.notify('write', Shuttlecraft::REGISTRATION_TEMPLATE)
    Thread.new do
      @registration_observer.each do |reg|
        puts "Recieved registration from #{reg[1][1]}"
      end
    end
  end

  def notify_on_unregistration
    @unregistration_observer = @ts.notify('take', Shuttlecraft::REGISTRATION_TEMPLATE)
    Thread.new do
      @unregistration_observer.each do |reg|
        puts "Recieved unregistration from #{reg[1][1]}"
      end
    end
  end

  def notify_on_write
    @write_observer = @ts.notify 'write', [nil]
    Thread.new do
      @write_observer.each {|n| p n}
    end
  end
end

if __FILE__ == $0
  m = Shuttlecraft::Mothership.new

  while(true)

    puts "Registered services: #{m.registered_services.join(', ')}"

    sleep(5)
  end

  DRb.thread.join
end
