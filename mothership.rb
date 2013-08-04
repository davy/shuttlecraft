#!/usr/bin/env ruby -w

require 'rinda/ring'
require 'rinda/tuplespace'

class Mothership

  attr_reader :ts, :provider

  REGISTRATION_TEMPLATE = [:name, nil, nil]

  def initialize
    @drb = DRb.start_service
    puts "Starting DRb Service on #{@drb.uri}"

    @ts = Rinda::TupleSpace.new


    @provider = Rinda::RingProvider.new(:Mothership, ts, 'Mothership')
    @provider.provide

    notify_on_registration
    notify_on_write
  end

  def registered_services
    @ts.read_all(REGISTRATION_TEMPLATE).collect{|_,name| name}
  end

  def notify_on_registration
    @registration_observer = @ts.notify('write', REGISTRATION_TEMPLATE)
    Thread.new do
      @registration_observer.each do |reg|
        puts "Recieved registration from #{reg[1]}"
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

m = Mothership.new

while(true)

  puts "Registered services: #{m.registered_services.join(', ')}"

  sleep(5)
end

DRb.thread.join
