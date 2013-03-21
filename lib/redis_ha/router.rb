require 'eventmachine'
require 'socket'

require 'redis_ha/router/upstream'
require 'redis_ha/router/connection'

module RedisHA
  module Router

    def self.start host, port, options={}, &block
      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }

        EventMachine::start_server(host, port, RedisHA::Router::Connection, options[:debug]) do |serv|
          serv.instance_eval &block
        end
      end
    end

    def self.stop
      EventMachine.stop
    end

  end
end