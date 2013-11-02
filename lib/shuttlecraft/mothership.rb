require 'rinda/ring'
require 'rinda/tuplespace'

class Shuttlecraft::Mothership

  include Shuttlecraft::Comms

  attr_reader :ts, :provider, :name, :protocol

  def initialize(opts={})
    initialize_comms(opts)

    @drb = DRb.start_service

    @protocol = opts[:protocol] || Shuttlecraft::Protocol.default
    @name = opts[:name] || @protocol.name

    @ts = Rinda::TupleSpace.new

    renewer = Rinda::SimpleRenewer.new 10

    @provider =
      Rinda::RingProvider.new(@protocol.service_name, @name, @ts, renewer)
    @provider.provide

    notify_on_registration
    notify_on_unregistration
    notify_on_write
  end

  def each_service_uri
    return enum_for __method__ unless block_given?

    registered_services.each do |_, uri|
      yield uri
    end
  end

  ##
  # Loops through each client and yields
  # DRb object for that client
  def each_client
    each_service_uri do |uri|
      begin
        remote = DRbObject.new_with_uri(uri)
        yield remote
      rescue DRb::DRbConnError
      rescue => e
        puts "hmm #{e.message}"
      end
    end
  end

  ##
  # Override this method to add custom registration restrictions
  def allow_registration?
    true
  end

  def notify_on_registration
    @registration_observer = @ts.notify('write', Shuttlecraft::REGISTRATION_TEMPLATE)
    Thread.new do
      @registration_observer.each do |reg|
        puts "Recieved registration from #{reg[1][1]}"
        unless allow_registration?
          puts "Registration not allowed"
          @ts.take(reg[1])
        end
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

  private

  ##
  # For Shuttlecraft::Comms
  def tuplespace
    @ts
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
