
class TestShuttlecraftHelper

  class StubRingServer
    def initialize; end
    def read(*args); return 'foo'; end
    def write(*args); return 'foo'; end
  end

  class StubMothership

    def initialize
      @tuples = []
    end

    def write(*args)
      @tuples << args
    end

    def take(*args)
      @tuples.delete(args)
    end

    def read_all(template)
      @tuples.map{|t,r| t}.select do |t|
        template[1].nil? or template[1] === t[1]
      end
    end
  end
end

class Rinda::RingFinger
  def primary
    TestShuttlecraftHelper::StubRingServer.new
  end
end
