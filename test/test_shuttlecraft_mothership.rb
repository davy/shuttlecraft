require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft/mothership'
require 'test_shuttlecraft_helper'

class TestShuttlecraftMothership < MiniTest::Unit::TestCase

  def setup
    @mothership = Shuttlecraft::Mothership.new('Enterprise')
  end

  def test_initialization
    assert_equal 'Enterprise', @mothership.name
    assert_equal [], @mothership.registered_services
  end

end
