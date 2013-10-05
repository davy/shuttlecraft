require 'shuttlecraft'

begin
  my_app = Shoes.app width: 360, height: 360, resizeable: false, title: 'Shuttlecraft' do

    @shuttlecraft = nil

    def display_screen
      clear do
        stack :margin => 20 do
          title "Shuttlecraft #{@shuttlecraft.name}"

          stack do @status = para end

          @registered = nil
          @updating_area = stack
        end

        animate(5) {
          if @shuttlecraft

            detect_registration_change

            if @registered
              @registrations.replace registrations_text
            end
          end
        }
      end
    end

    def detect_registration_change
      if @registered != @shuttlecraft.registered?
        @registered = @shuttlecraft.registered?
        @status.replace "#{"Not " unless @registered}Registered"
        @updating_area.clear do
          if @registered
            button("Unregister") { unregister }
            button("Broadcast") {
              @shuttlecraft.broadcast("hello from #{@shuttlecraft.name}")
            }
            stack do
              para 'Registered Services:'
              @registrations = para
            end
          else
            button("Register")    { register }
          end
        end
      end
    end

    def launch_screen
      clear do
        background black
        title "Build Shuttlecraft", stroke: white
        el = edit_line text: 'Name' do |s|
          @name = s.text
        end
        button('launch') {
          @shuttlecraft = Shuttlecraft.new(@name)
          initiate_comms_screen
        }
      end
    end

    def initiate_comms_screen
      clear do
        background black
        title "Initiate Comms", stroke: white

        stack do
          motherships = @shuttlecraft.find_all_motherships

          for mothership in motherships
            button(mothership[:name]) {|b|
              begin
                @shuttlecraft.initiate_communication_with_mothership(b.text)
              rescue
                initiate_comms_screen
              end
              display_screen
            }
          end

          if motherships.empty?
            subtitle "No Motherships within range", stroke: white
          end
          button('rescan') {
            initiate_comms_screen
          }
        end
      end
    end

    def register
      @shuttlecraft.register if @shuttlecraft
    end

    def unregister
      @shuttlecraft.unregister if @shuttlecraft
    end

    def registrations_text
      @shuttlecraft.registered_services.join(', ') if @shuttlecraft
    end

    launch_screen
  end

ensure
  my_app.unregister if my_app
end
