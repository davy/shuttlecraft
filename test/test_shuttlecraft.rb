require 'minitest/autorun'

require 'rubygems'
require 'shuttlecraft'

class StubRingServer

  def initialize
  end

  def read(*args)
    return 'foo'
  end

end

class StubMothership

  def initialize
    @tuples = []
  end

  def write(*args)
    @tuples << args
  end

  def take(*args)
    @tuples.delete(args)
  end

  def read_all(template)
    @tuples.map{|t,r| t}.select do |t|
      template[1].nil? or t[1] == template[1]
    end
  end
end

class Rinda::RingFinger

  def primary
     StubRingServer.new
  end
end


class TestShuttlecraft < MiniTest::Unit::TestCase


  def setup
    @shuttlecraft = Shuttlecraft.new
    @stub_mothership = StubMothership.new
    @shuttlecraft.mothership = @stub_mothership 
  end


  def test_initialize_registered
    assert_equal false, @shuttlecraft.registered?
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
