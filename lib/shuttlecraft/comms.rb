##
# Must define tuplespace to read from
#    def tuplespace
#
# Must call initialize_comms inside initialize
#
class Shuttlecraft
  module Comms

    def initialize_comms(opts={})
      @registered_services_ary = []
      @update_every = opts[:update_every] || 2
      @last_update = Time.at 0
    end

    def registered_services
      update
      @registered_services_ary
    end

    ##
    # Registered services are only updatable if they haven't been updated in the
    # last @update_every seconds. This prevents DRb message spam.
    def update?
      (@last_update + @update_every) < Time.now
    end

    ##
    # Retrieve the last registration data from the TupleSpace.
    def update
      return unless update?
      @last_update = Time.now
      @registered_services_ary = read_registered_services
    end

    ##
    # Forces retrieval of registrations from the TupleSpace.
    def update!
      @last_update = Time.at 0
      update
    end

    def each_service_uri
      return enum_for __method__ unless block_given?

      registered_services.each do |_, uri|
        yield uri
      end
    end

    private

    def read_registered_services
      begin
        tuplespace.read_all(Shuttlecraft::REGISTRATION_TEMPLATE).collect{|_,name,uri| [name,uri]}
      rescue DRb::DRbConnError
        []
      end
    end

  end
end
