#!/usr/bin/env ruby -w

require 'rinda/ring'

class ShuttleCraft

  attr_accessor :ring_server, :mothership

  def initialize(name='foo')
    @drb = DRb.start_service
    puts "Starting DRb Service on #{@drb.uri}"

    @ring_server = Rinda::RingFinger.primary
    @name = name

    query_mothership
  end

  def query_mothership
    @mothership = ring_server.read([:name, :Mothership, nil, nil])[2]
    @mothership = Rinda::TupleSpaceProxy.new @mothership
  end

  def register
    unless registered?
      @mothership.write([:name, @name, DRb.uri])
    end
  end

  def registered?
    !@mothership.read_all([:name, nil, nil])
      .detect{|t| t[1] == @name && t[2] == DRb.uri}
      .nil?
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

s = ShuttleCraft.new
s.register

sleep(5)

s.unregister

