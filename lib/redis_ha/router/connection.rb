module RedisHA
  module Router
    class Connection < EventMachine::Connection
      include RedisHA::Logger

      def on_data(&block);     @on_data     = block; end
      def on_response(&block); @on_response = block; end
      def on_finish(&block);   @on_finish   = block; end
      def on_connect(&block);  @on_connect  = block; end

      def initialize(debug_on=false)
        @debug = debug_on
        @upstreams = {}
      end

      def receive_data data
        logger.debug [:connection, data]
        processed = @on_data.call(data) if @on_data

        return if processed == :async or processed.nil?
        relay_to_upstreams(processed)
      end

      def relay_to_upstreams processed
        if processed.is_a? Array
          data, servers = *processed
          servers = servers.collect {|s| @upstreams[s]}.compact
        else
          data = processed
          servers ||= @upstreams.values.compact
        end

        servers.each do |s|
          s.send_data data unless data.nil?
        end
      end

      def upstream name, options
        serv = EventMachine::bind_connect(*build_upstream_signature(options)) do |c|
          c.name = name
          c.plexer = self
          c.proxy_incoming_to(self, 10240) if options[:relay_server]
        end

        self.proxy_incoming_to(serv, 10240) if options[:relay_client]

        @upstreams[name] = serv
      end

      def peer
        @peer ||= begin
          peername = get_peername
          peername ? Socket.unpack_sockaddr_in(peername).reverse : nil
        end
      end

      def relay_from_upstream name, data
        logger.debug [:relay_from_upsteam, name, data]
        data = @on_response.call(name, data) if @on_response
        send_data data unless data.nil?
      end

      def connected name
        logger.debug [:connected]
        @on_connect.call(name) if @on_connect
      end

      def unbind
        logger.debug [:unbind, :connection]

        @upstreams.values.compact.each do |serv|
          serv.close_connection
        end
      end

      def unbind_backend name
        logger.debug [:unbind_backend, name]
        @upstreams[name] = nil
        close = :close

        if @on_finish
          close = @on_finish.call(name)
        end

        if (@upstreams.values.compact.size.zero? && close != :keep) || close == :close
          close_connection_after_writing
        end
      end

      private
      def build_upstream_signature options
        [options[:bind_host], 
         options[:bind_port], 
         options[:host],
         options[:port], 
         RedisHA::Router::Upstream, 
         @debug]
      end
    end
  end
end