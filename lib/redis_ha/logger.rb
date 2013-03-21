require 'active_support/concern'
require 'logger'

module RedisHA
  module Logger
    extend ActiveSupport::Concern

    included do
      def logger
        @logger ||= begin  
          log = ::Logger.new(STDOUT)
          log.level = (@debug ? ::Logger::DEBUG : ::Logger::INFO)
          log
        end
      end
    end
  end
end