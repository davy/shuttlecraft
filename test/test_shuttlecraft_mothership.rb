require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft/mothership'
require 'test_shuttlecraft_helper'

class TestShuttlecraftMothership < MiniTest::Unit::TestCase

  def setup
    @mothership = Shuttlecraft::Mothership.new(name: 'Enterprise')
  end

  def test_initialization
    assert_equal 'Enterprise', @mothership.name
    assert_equal :Mothership, @mothership.protocol.service_name
    assert_equal [], @mothership.registered_services
  end

  def test_uses_default_protocol
    assert_equal Shuttlecraft::Protocol.default, @mothership.protocol
  end

  def test_update_eh
    assert @mothership.update?

    refute @mothership.update?
  end

  def test_update
    assert_empty @mothership.registered_services

    make_registrations(%w[Davy Eric])

    assert_empty @mothership.registered_services

    assert @mothership.update
    refute @mothership.update

    assert_equal %w[Davy Eric], @mothership.registered_services.collect{|n,u| n}.sort
  end

  def test_update_bang
    make_registrations(%w[Davy Eric])
    assert @mothership.update

    assert_equal %w[Davy Eric], @mothership.registered_services.collect{|n,u| n}.sort

    make_registrations(%w[Davy Eric Rein])
    assert @mothership.update!

    assert_equal %w[Davy Eric Rein], @mothership.registered_services.collect{|n,u| n}.sort
  end

  def make_registrations regs

    @@regs = regs

    def @mothership.read_registered_services
      @@regs.collect{|r| [r, DRb.uri]}
    end
  end

end