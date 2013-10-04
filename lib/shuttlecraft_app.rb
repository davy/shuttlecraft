require 'shuttlecraft'

begin
  my_app = Shoes.app :width => 360, :height => 360, :resizeable => false,
   :title => 'Shuttlecraft' do

    @shuttlecraft = nil

    def display_screen
      clear do
        stack :margin => 20 do
          title "Shuttlecraft #{@shuttlecraft.name}"

          stack do @status = para end

          button("Register") { register }
          button("Unregister") { unregister }
        end
        animate(5) {@status.replace status_text}
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
            button(mothership[0]) {
              begin
                @shuttlecraft.initiate_communication_with_mothership(mothership[0])
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

    def status_text
      "Registered? #{@shuttlecraft.registered? if @shuttlecraft}"
    end

    def register
      @shuttlecraft.register if @shuttlecraft
    end

    def unregister
      @shuttlecraft.unregister if @shuttlecraft
    end

    launch_screen
  end

ensure
  my_app.unregister if my_app
end
