require 'resolv'

class Resolv

  class DNS
    class Requester

      remove_method :request

      def request(sender, tout)
        start = Time.now
        timelimit = start + tout
        begin
          sender.send
        rescue Errno::EHOSTUNREACH
          # multi-homed IPv6 may generate this
          raise ResolvTimeout
        end
        while true
          before_select = Time.now
          timeout = timelimit - before_select
          if timeout <= 0
            raise ResolvTimeout
          end
          select_result = IO.select(@socks, nil, nil, timeout)
          if !select_result
            after_select = Time.now
            next if after_select < timelimit
            raise ResolvTimeout
          end
          begin
            reply, from = recv_reply(select_result[0])
          rescue Errno::ECONNREFUSED, # GNU/Linux, FreeBSD
                 Errno::ECONNRESET # Windows
            # No name server running on the server?
            # Don't wait anymore.
            raise ResolvTimeout
          end
          begin
            msg = Message.decode(reply)
          rescue DecodeError
            next # broken DNS message ignored
          end
          if s = sender_for(from, msg)
            break
          else
            # unexpected DNS message ignored
          end
        end
        return msg, s.data
      end

      def sender_for(addr, msg)
        @senders[[addr,msg.id]]
      end

      class MDNSOneShot < UnconnectedUDP # :nodoc:
        def sender(msg, data, host, port=Port)
          id = DNS.allocate_request_id(host, port)
          request = msg.encode
          request[0,2] = [id].pack('n')
          sock = @socks_hash[host.index(':') ? "::" : "0.0.0.0"]
          return @senders[id] =
            UnconnectedUDP::Sender.new(request, data, sock, host, port)
        end

        def sender_for(addr, msg)
          @senders[msg.id]
        end
      end
    end
  end

  ##
  # Resolv::MDNS is a one-shot Multicast DNS (mDNS) resolver.  It blindly
  # makes queries to the mDNS addresses without understanding anything about
  # multicast ports.
  #
  # Information taken form the following places:
  #
  # * RFC 6762

  class MDNS < DNS

    ##
    # Default mDNS Port

    Port = 5353

    ##
    # Default IPv4 mDNS address

    AddressV4 = '224.0.0.251'

    ##
    # Default IPv6 mDNS address

    AddressV6 = 'ff02::fb'

    ##
    # Default mDNS addresses

    Addresses = [
      [AddressV4, Port],
      [AddressV6, Port],
    ]

    ##
    # Creates a new one-shot Multicast DNS (mDNS) resolver.
    #
    # +config_info+ can be:
    #
    # nil::
    #   Uses the default mDNS addresses
    #
    # Hash::
    #   Must contain :nameserver or :nameserver_port like
    #   Resolv::DNS#initialize.

    def initialize(config_info=nil)
      if config_info then
        super({ nameserver_port: Addresses }.merge(config_info))
      else
        super(nameserver_port: Addresses)
      end
    end

    ##
    # Iterates over all IP addresses for +name+ retrieved from the mDNS
    # resolver, provided name ends with "local".  If the name does not end in
    # "local" no records will be returned.
    #
    # +name+ can be a Resolv::DNS::Name or a String.  Retrieved addresses will
    # be a Resolv::IPv4 or Resolv::IPv6

    def each_address(name)
      name = Resolv::DNS::Name.create(name)

      return unless name.to_a.last == 'local'

      super(name)
    end

    def make_udp_requester # :nodoc:
      nameserver_port = @config.nameserver_port
      Requester::MDNSOneShot.new(*nameserver_port)
    end

  end

  def DefaultResolver.replace_resolvers new_resolvers
    @resolvers = new_resolvers
  end

end unless Resolv.const_defined? :MDNS

require 'resolv-replace'

resolvers = [
  Resolv::MDNS.new,
  Resolv::Hosts.new,
  Resolv::DNS.new,
]

Resolv::DefaultResolver.replace_resolvers resolvers

