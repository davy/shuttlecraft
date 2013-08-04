#!/usr/bin/env ruby -w

require 'rinda/ring'
require 'rinda/tuplespace'

DRb.start_service

Rinda::RingServer.new Rinda::TupleSpace.new

DRb.thread.join
