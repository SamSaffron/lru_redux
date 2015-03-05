require 'lru_redux'
require 'minitest/autorun'
require 'minitest/pride'

class ExpiringCacheTest < MiniTest::Test
  def setup
    @long_expiring_cache = LruRedux::ExpiringCache.new(3, 100)
    @immediately_expiring_cache = LruRedux::ExpiringCache.new(3, 0)
  end

  def teardown
    assert_equal true, @long_expiring_cache.valid?
  end

  def test_drops_old_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3
    @long_expiring_cache[:d] = 4

    assert_equal [[:d,4],[:c,3],[:b,2]], @long_expiring_cache.to_a
    assert_nil @long_expiring_cache[:a]
  end

  def test_fetch_long
    @long_expiring_cache[:a] = nil
    @long_expiring_cache[:b] = 2
    assert_equal @long_expiring_cache.fetch(:a){1}, nil
    assert_equal @long_expiring_cache.fetch(:c){3}, 3

    assert_equal [[:a,nil],[:b,2]], @long_expiring_cache.to_a
  end

  def test_getset_long
   assert_equal @long_expiring_cache.getset(:a){1}, 1
   @long_expiring_cache.getset(:b){2}
   assert_equal @long_expiring_cache.getset(:a){11}, 1
   @long_expiring_cache.getset(:c){3}
   assert_equal @long_expiring_cache.getset(:d){4}, 4

    assert_equal [[:d,4],[:c,3],[:a,1]], @long_expiring_cache.to_a
  end

  def test_pushes_lru_to_back_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3

    @long_expiring_cache[:a]
    @long_expiring_cache[:d] = 4

    assert_equal [[:d,4],[:a,1],[:c,3]], @long_expiring_cache.to_a
    assert_nil @long_expiring_cache[:b]
  end


  def test_delete_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3

    @long_expiring_cache.delete(:b)
    assert_equal [[:c,3],[:a,1]], @long_expiring_cache.to_a
    assert_nil @long_expiring_cache[:b]
  end

  def test_update_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3
    @long_expiring_cache[:a] = 99
    assert_equal [[:a,99],[:c,3],[:b,2]], @long_expiring_cache.to_a
  end

  def test_clear_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3

    @long_expiring_cache.clear
    assert_equal [], @long_expiring_cache.to_a
  end

  def test_grow_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3
    @long_expiring_cache.max_size = 4
    @long_expiring_cache[:d] = 4
    assert_equal [[:d,4],[:c,3],[:b,2],[:a,1]], @long_expiring_cache.to_a
  end

  def test_shrink_long
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3
    @long_expiring_cache.max_size = 1
    assert_equal [[:c,3]], @long_expiring_cache.to_a
  end

  def test_each_long
    @long_expiring_cache.max_size = 2
    @long_expiring_cache[:a] = 1
    @long_expiring_cache[:b] = 2
    @long_expiring_cache[:c] = 3

    pairs = []
    @long_expiring_cache.each do |pair|
      pairs << pair
    end

    assert_equal [[:c,3],[:b, 2]], pairs
  end

  def test_expires_immediately
    @immediately_expiring_cache[:a] = 1
    @immediately_expiring_cache[:b] = 2

    assert_equal nil, @immediately_expiring_cache[:a]
    assert_equal nil, @immediately_expiring_cache[:b]
  end

  def test_expires_immediately_getset
    @immediately_expiring_cache[:a] = 1
    @immediately_expiring_cache[:b] = 2
    cache_used = true

    @immediately_expiring_cache.getset(:a) do
      cache_used = false
    end
    assert_equal false, cache_used
  end

  def test_expires_immediately_fetch
    @immediately_expiring_cache[:a] = 1
    @immediately_expiring_cache[:b] = 2
    cache_used = true

    @immediately_expiring_cache.fetch(:a) do
      cache_used = false
    end
    assert_equal false, cache_used
  end
end
