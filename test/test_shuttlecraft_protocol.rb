require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft/protocol'

class TestShuttlecraftProtocol < MiniTest::Unit::TestCase

  def setup
    @protocol = Shuttlecraft::Protocol.new(:MySpecialProtocol, 'Special Snowflake')
  end

  def test_initialization
    assert_equal :MySpecialProtocol, @protocol.service_name
    assert_equal "Special Snowflake", @protocol.name
  end

  def test_default_protocol
    assert_equal :Mothership, Shuttlecraft::Protocol.default.service_name
    assert_equal "Mothership", Shuttlecraft::Protocol.default.name
  end
end
