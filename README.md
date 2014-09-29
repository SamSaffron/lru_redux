# LruRedux

An efficient thread safe lru cache.

Lru Redux uses a Hash/Double link list backed storage to keep track of nodes in a cache based on last usage.

This provides a correct and well specified LRU cache, that is very efficient. Additionally you can optionally use a thread safe wrapper.

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
cache = LruRedux::Cache.new(100)
cache[:a] = "1"
cache[:b] = "2"

cache.to_a
# [[:b,"2"],[:a,"1"]]
# note the order matters here, last accessed is first

cache[:a] # a pushed to front
# "1"

cache.to_a
# [[:a,"1"],[:b,"2"]]
cache.delete(:a)
cache.each {|k,v| p "#{k} #{v}"}
# b 2

cache.max_size(200) # cache now stores 200 items
cache.clear # cache has no items

cache.getset(:a){1}
cache.to_a
#[[:a,1]]

# already set so don't call block
cache.getset(:a){99}
cache.to_a
#[[:a,1]]

# for thread safe access, all methods on cache
# are protected with a mutex
cache = LruRedux::ThreadSafeCache.new(100)

```

## Benchmarks

see: benchmark directory (a million random lookup / store)

```
sam@ubuntu:~/Source/lru_redux/bench$ ruby ./bench.rb
Rehearsal ---------------------------------------------------------
thread safe lru        27.940000   0.020000  27.960000 ( 28.026869)
lru gem                 2.250000   0.010000   2.260000 (  2.256652)
lru_cache gem           1.980000   0.000000   1.980000 (  1.979244)
lru_redux gem           1.190000   0.000000   1.190000 (  1.187640)
lru_redux thread safe   2.480000   0.000000   2.480000 (  2.486314)
----------------------------------------------- total: 35.870000sec

                            user     system      total        real
thread safe lru        28.010000   0.000000  28.010000 ( 28.023534)
lru gem                 2.250000   0.000000   2.250000 (  2.256425)
lru_cache gem           1.920000   0.000000   1.920000 (  1.925362)
lru_redux gem           1.170000   0.000000   1.170000 (  1.170970)
lru_redux thread safe   2.480000   0.000000   2.480000 (  2.488169)

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changlog


###version 0.8.1 - 7-Sep-2013

- Fix #each implementation
- Fix deadlocks with ThreadSafeCache
- Version jump is because its been used in production for quite a while now

###version 0.0.6 - 24-April-2013

- Fix bug in getset, overflow was not returning the yeilded val

###version 0.0.5 - 23-April-2013

- Added getset and fetch
- Optimised implementation so it 20-30% faster on Ruby 1.9+

###version 0.0.4 - 23-April-2013

- Initial version
