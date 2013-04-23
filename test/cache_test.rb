require 'lru_redux'
require 'minitest/autorun'
require 'minitest/pride'

class CacheTest < MiniTest::Unit::TestCase
  def setup
    @c = LruRedux::Cache.new(3)
  end

  def teardown
    assert_equal true, @c.valid?
  end

  def test_drops_old
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c[:d] = 4

    assert_equal [[:d,4],[:c,3],[:b,2]], @c.to_a
    assert_nil @c[:a]
  end

  def test_fetch
    @c[:a] = nil
    @c[:b] = 2
    assert_equal @c.fetch(:a){1}, nil
    assert_equal @c.fetch(:c){3}, 3

    assert_equal [[:a,nil],[:b,2]], @c.to_a
  end

  def test_getset
   @c.getset(:a){1}
   @c.getset(:b){2}
   assert_equal @c.getset(:a){11}, 1
   @c.getset(:c){3}
   @c.getset(:d){4}

    assert_equal [[:d,4],[:c,3],[:a,1]], @c.to_a
  end

  def test_pushes_lru_to_back
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3

    @c[:a]
    @c[:d] = 4

    assert_equal [[:d,4],[:a,1],[:c,3]], @c.to_a
    assert_nil @c[:b]
  end


  def test_delete
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3

    @c.delete(:b)
    assert_equal [[:c,3],[:a,1]], @c.to_a
    assert_nil @c[:b]
  end

  def test_update
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c[:a] = 99
    assert_equal [[:a,99],[:c,3],[:b,2]], @c.to_a
  end

  def test_clear
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3

    @c.clear
    assert_equal [], @c.to_a
  end

  def test_grow
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c.max_size = 4
    @c[:d] = 4
    assert_equal [[:d,4],[:c,3],[:b,2],[:a,1]], @c.to_a
  end

  def test_shrink
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c.max_size = 1
    assert_equal [[:c,3]], @c.to_a
  end
end
