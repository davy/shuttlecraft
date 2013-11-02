class MyShuttlecraft < Shuttlecraft

  attr_reader :msg_log

  def initialize(opts={})
    super(opts)
    @msg_log = []
  end

  def broadcast(msg)
    for _, uri in registered_services
      begin
        remote = DRbObject.new_with_uri(uri)
        remote.say(msg, DRb.uri)
      rescue DRb::DRbConnError
      end
    end
  end

  def say(msg, from)
    @msg_log << msg
    begin
      remote = DRbObject.new_with_uri(from)
      remote.message_reciept(@name)
    rescue DRb::DRbConnError
    end
  end

  def message_reciept(from)
    puts "reciept from #{from}"
  end
end

class Shuttlecraft::ShuttlecraftApp

  def self.run
    @my_app = Shoes.app width: 360, height: 360, resizeable: false, title: 'Shuttlecraft' do

      @shuttlecraft = nil

      def display_screen
        clear do
          stack :margin => 20 do
            title "Shuttlecraft #{@shuttlecraft.name}"

            stack do @status = para end

            @registered = nil
            @updating_area = stack
            @msg_stack = stack
          end

          animate(5) {
            if @shuttlecraft

              detect_registration_change

              if @registered
                @registrations.replace registrations_text

                @msg_stack.clear do
                  for msg in @shuttlecraft.msg_log
                    para msg
                  end
                end
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

              el = edit_line

              button("Send") {
                @shuttlecraft.broadcast(el.text)
                el.text = ''
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
          edit_line text: 'Name' do |s|
            @name = s.text
          end
          button('launch') {
            @shuttlecraft = MyShuttlecraft.new(name: @name)
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

            if motherships.empty?
              subtitle "No Motherships within range", stroke: white
            else
              subtitle "Select Mothership", stroke: white
            end
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

            button('launch mothership') {
              load File.dirname(__FILE__) + '/mothership_app.rb'
            }
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
        if @shuttlecraft
          @shuttlecraft.update
          @shuttlecraft.registered_services.join(', ')
        end
      end

      launch_screen
    end
  ensure
    @my_app.unregister if @my_app
  end
end
