module RedisHA
  module Router
    class Upstream < EventMachine::Connection
      include RedisHA::Logger

      attr_accessor :plexer, :name, :debug

      def initialize debug_on=false
        @debug = debug_on
        @connected = EM::DefaultDeferrable.new
      end

      def connection_completed
        logger.debug [@name, :conn_complete]
        @plexer.connected(@name)
        @connected.succeed
      end

      def receive_data data
        logger.debug [@name, data]
        @plexer.relay_from_upstream(@name, data)
      end

      def send data
        @connected.callback { send_data data }
      end

      def ubind
        logger.debug [@name, :unbind]
        @plexer.unbind_backend(@name)
      end
    end
  end
end