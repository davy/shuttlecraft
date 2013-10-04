require 'shuttlecraft/mothership'

Shoes.app :width => 360, :height => 360, :resizeable => false,
 :title => 'Mothership' do

  @mothership = nil

  def display_screen
    clear do
      background "#ffffff"

      stack :margin => 20 do
        title "Mothership #{@mothership.name}"

        stack do
          para 'Registered Services:'
          @registrations = para
        end
      end
      animate(5) { @registrations.replace registrations_text}
    end
  end

  def registrations_text
    @mothership.registered_services.join(', ') if @mothership
  end

  def launch_screen
    clear do
      background black
      title "Build Mothership", stroke: white
      el = edit_line text: 'Name' do |s|
        @name = s.text
      end
      button('launch') {
        @mothership = Shuttlecraft::Mothership.new(@name)
        display_screen
      }
    end
  end

  launch_screen
end
