require 'lru_redux'
require 'minitest/autorun'
require 'minitest/pride'

class ThreadSafeCacheTest < MiniTest::Unit::TestCase
  def test_additions
    cache = LruRedux::ThreadSafeCache.new(1000)
    threads = []
    4.times do |t|
      threads << Thread.new do
        250.times do |i|
          cache[i] = "#{t} #{i}"
        end
      end
    end

    threads.each{|t| t.join}
    assert_equal cache.count,250
    assert true, cache.valid?

  end
end
