require 'rubygems'
require 'lru'
require 'benchmark'
require 'lru_cache'
require 'threadsafe-lru'
$LOAD_PATH.unshift File.expand_path '../lib'
require File.expand_path('../../lib/lru_redux', __FILE__)

lru = Cache::LRU.new(max_elements: 1_000)
lru_cache = LRUCache.new(1_000)

lru_redux = LruRedux::Cache.new(1_000)
lru_redux_thread_safe = LruRedux::ThreadSafeCache.new(1_000)
thread_safe_lru = ThreadSafeLru::LruCache.new(1_000)

bm = Benchmark.bmbm do |bm|

  bm.report "thread safe lru" do
    1_000_000.times do
      thread_safe_lru.get(rand(2_000)){ :value }
    end
  end

  [
    [lru, "lru gem"],
    [lru_cache, "lru_cache gem"],
  ].each do |cache, name|
    bm.report name do
      1_000_000.times do
        cache[rand(2_000)] ||= :value
      end
    end
  end

  [
      [lru_redux, "lru_redux gem"],
      [lru_redux_thread_safe, "lru_redux thread safe"]
  ].each do |cache, name|
    bm.report name do
      1_000_000.times do
        cache.getset(rand(2_000)) { :value }
      end
    end
  end
end
