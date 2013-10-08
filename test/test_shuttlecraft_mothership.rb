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

end
