class Shuttlecraft::Protocol

  attr_reader :service_name, :name

  def initialize(service_name=:Mothership, name='Mothership')
    @service_name = service_name
    @name = name
  end

  def self.default
    @@default ||= Shuttlecraft::Protocol.new
    @@default
  end
end
