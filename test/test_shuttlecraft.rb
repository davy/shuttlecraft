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
    assert_equal [], @shuttlecraft.registered_services
  end

  def test_each_service_uri
    @shuttlecraft.registered_services << ['name', DRb.uri]

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

  def test_update_eh
    assert @shuttlecraft.update?

    @shuttlecraft.update

    refute @shuttlecraft.update?
  end

  def test_update
    assert_empty @shuttlecraft.registered_services

    make_registrations(%w[Davy Eric])

    assert_empty @shuttlecraft.registered_services

    assert @shuttlecraft.update
    refute @shuttlecraft.update

    assert_equal %w[Davy Eric], @shuttlecraft.registered_services.collect{|n,u| n}.sort
  end

  def test_update_bang
    make_registrations(%w[Davy Eric])
    assert @shuttlecraft.update

    assert_equal %w[Davy Eric], @shuttlecraft.registered_services.collect{|n,u| n}.sort

    make_registrations(%w[Davy Eric Rein])
    assert @shuttlecraft.update!

    assert_equal %w[Davy Eric Rein], @shuttlecraft.registered_services.collect{|n,u| n}.sort
  end

  def make_registrations regs

    @@regs = regs

    class << @shuttlecraft
      undef_method :read_registered_services
    end

    def @shuttlecraft.read_registered_services
      @@regs.collect{|r| [r, DRb.uri]}
    end
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
