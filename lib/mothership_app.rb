require 'shuttlecraft/mothership'

Shoes.app :width => 360, :height => 360, :resizeable => false do

  background "#ffffff"

  stack :margin => 20 do
    title "Mothership"

    stack do 
      para 'Registered Services:'
      @registrations = para 
    end
  end

  @mothership = Shuttlecraft::Mothership.new

  animate(5) { @registrations.replace registrations_text}

  def registrations_text
    @mothership.registered_services.join(', ')
  end
end
