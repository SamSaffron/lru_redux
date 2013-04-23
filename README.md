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

## Benchmarks

see: benchmark directory

```
sam@ubuntu:~/Source/lru_redux/bench$ ruby ./bench.rb
Rehearsal ---------------------------------------------------------
thread safe lru        27.940000   0.020000  27.960000 ( 28.000938)
lru gem                 2.300000   0.000000   2.300000 (  2.305732)
lru_cache gem           1.960000   0.010000   1.970000 (  1.975683)
lru_redux gem           1.710000   0.000000   1.710000 (  1.704134)
lru_redux thread safe   2.830000   0.000000   2.830000 (  2.837608)
----------------------------------------------- total: 36.770000sec

                            user     system      total        real
thread safe lru        27.740000   0.000000  27.740000 ( 27.756163)
lru gem                 2.250000   0.000000   2.250000 (  2.252772)
lru_cache gem           1.960000   0.000000   1.960000 (  1.963679)
lru_redux gem           1.710000   0.000000   1.710000 (  1.712147)
lru_redux thread safe   2.750000   0.000000   2.750000 (  2.752526)

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changlog

###verson 0.0.2 - 23-April-2013

- Added .clear method
