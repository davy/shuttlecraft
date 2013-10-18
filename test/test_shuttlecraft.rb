require 'shuttlecraft/test'

class TestShuttlecraft < Shuttlecraft::Test

  def setup
    @shuttlecraft = Shuttlecraft.new(name: 'Galileo')
    @shuttlecraft.mothership = Shuttlecraft::Test::StubMothership.new
    @stub_mothership = @shuttlecraft.mothership
  end

  def test_initialization
    assert_equal false, @shuttlecraft.registered?
    assert_equal 'Galileo', @shuttlecraft.name
    assert_equal :Mothership, @shuttlecraft.protocol.service_name
  end

  def test_each_service_uri
    @stub_mothership.write [:name, 'name', DRb.uri]

    e = @shuttlecraft.each_service_uri

    assert_equal DRb.uri, e.next

    uris = []

    @shuttlecraft.each_service_uri do |uri|
      uris << uri
    end

    refute_empty uris
  end

  def test_uses_default_protocol
    assert_equal Shuttlecraft::Protocol.default, @shuttlecraft.protocol
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
