require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft'
require 'test_shuttlecraft_helper'

class TestShuttlecraft < MiniTest::Unit::TestCase

  def setup
    @shuttlecraft = Shuttlecraft.new('Galileo')
    @shuttlecraft.mothership = TestShuttlecraftHelper::StubMothership.new
    @stub_mothership = @shuttlecraft.mothership
  end

  def test_initialization
    assert_equal false, @shuttlecraft.registered?
    assert_equal 'Galileo', @shuttlecraft.name
  end

  def test_registration
    @shuttlecraft.register

    assert_equal true, @shuttlecraft.registered?
  end

  def test_unregistration
    @stub_mothership.write([:name, @shuttlecraft.name, DRb.uri])

    assert_equal true, @shuttlecraft.registered?

    @shuttlecraft.unregister

    assert_equal false, @shuttlecraft.registered?
  end
end
