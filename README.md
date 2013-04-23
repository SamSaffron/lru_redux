# LruRedux

An efficient thread safe lru cache

## Installation

Add this line to your application's Gemfile:

    gem 'lru_redux'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lru_redux

## Usage

```ruby
require 'lru_redux'
# non thread safe
cache = LruRedux::Cache(100)
cache[:a] = "1"
cache.to_a
# [[:a,"1"]]
cache.delete(:a)
cache.each {|k,v| p "#{k} #{v}"}
# nothing

# for thread safe
cache = LruRedux::ThreadSafeCache(100)

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
