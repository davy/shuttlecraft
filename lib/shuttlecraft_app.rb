require 'shuttlecraft'

Shoes.app :width => 360, :height => 360, :resizeable => false do

  @shuttlecraft = nil

  stack :margin => 20 do
    title "Shuttlecraft"

    stack do @status = para end

    button("Register") { register }
    button("Unregister") { unregister }
  end

  animate(5) {@status.replace status_text} 

  def status_text
    "Registered? #{@shuttlecraft.registered? if @shuttlecraft}"
  end

  def register
    @shuttlecraft.register if @shuttlecraft
  end

  def unregister
    @shuttlecraft.unregister if @shuttlecraft
  end

  @shuttlecraft = Shuttlecraft.new

end
