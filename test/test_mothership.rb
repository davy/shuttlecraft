require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft/mothership'

class StubRingServer
  def initialize; end
  def read(*args); return 'foo'; end
  def write(*args); return 'foo'; end
end

class Rinda::RingFinger
  def primary
    StubRingServer.new
  end
end

class TestMothership < MiniTest::Unit::TestCase

  def setup
    @mothership = Shuttlecraft::Mothership.new('Enterprise')
  end

  def test_initialization
    assert_equal 'Enterprise', @mothership.name
    assert_equal [], @mothership.registered_services
  end

end
