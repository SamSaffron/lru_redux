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
cache = LruRedux::ThreadSafeCache(100)

```

## Benchmarks

see: benchmark directory

```
sam@ubuntu:~/Source/lru_redux/bench$ ruby ./bench.rb
Rehearsal ---------------------------------------------------------
thread safe lru        27.640000   0.370000  28.010000 ( 28.049021)
lru gem                 2.460000   0.000000   2.460000 (  2.454292)
lru_cache gem           2.170000   0.000000   2.170000 (  2.174306)
lru_redux gem           1.530000   0.020000   1.550000 (  1.552481)
lru_redux thread safe   2.610000   0.070000   2.680000 (  2.684895)
----------------------------------------------- total: 36.870000sec

                            user     system      total        real
thread safe lru        28.170000   0.280000  28.450000 ( 28.465008)
lru gem                 2.330000   0.000000   2.330000 (  2.328316)
lru_cache gem           2.140000   0.000000   2.140000 (  2.142749)
lru_redux gem           1.640000   0.000000   1.640000 (  1.643732)
lru_redux thread safe   2.590000   0.000000   2.590000 (  2.600422)

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changlog

###version 0.0.4 - 23-April-2013

- Initial version
