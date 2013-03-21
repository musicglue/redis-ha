# RedisHA

THIS IS CURRENTLY NOT FUNCTIONING - IN DEVELOPMENT ONLY

RedisHA is a Highly Available solution for running Redis under situations other than as a cacheing layer, specifically for where single server operations are required and thus sharding is not an option (e.g. Queueing, Lua based ops).

RedisHA consists of two parts - a Router and a Manager.

## Router

The Router layer acts as a single interface point to your Redis installations, and is essentially a high-performance reverse proxy layer to your Redis installations.

## Installation

Add this line to your application's Gemfile:

    gem 'redis-ha'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-ha

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
