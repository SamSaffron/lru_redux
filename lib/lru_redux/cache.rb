

class LruRedux::Cache

  # for high efficiency nodes in double linked list are stored in arrays
  # [prev,key,val,next]
  #
  # This makes this much more annoying to code, but gives us a 5-10% edge

  def initialize(max_size)
    @max_size = max_size
    @data = {}
    @head = nil
    @tail = nil
  end

  def max_size=(size)
    raise ArgumentError.new(:max_size) if @max_size < 1
    @max_size = size
    while pop_tail
      # no op
    end
  end

  def getset(key)
    node = @data[key]
    if node
      move_to_head(node)
      node[2]
    else
      self[key] = yield
    end
  end

  def fetch(key)
    node = @data[key]
    if node
      move_to_head(node)
      node[2]
    else
      yield if block_given?
    end
  end

  def [](key)
    node = @data[key]
    if node
      move_to_head(node)
      node[2]
    end
  end

  def []=(key,val)
    node = @data[key]
    if node
      move_to_head(node)
      node[2] = val
    else
      @data[key] = add_to_head(key,val)
      pop_tail
    end
    val
  end

  def each
    a = to_a
    a.each do |pair|
      yield pair
    end
  end

  def each_unsafe
    n = @head
    if n
      while n
        yield [n[1], n[2]]
        n = n[0]
      end
    end
  end

  def to_a
    a = []
    self.each_unsafe do |k,v|
      a << [k,v]
    end
    a
  end

  def delete(key)
    node = @data.delete(key)

    return unless node

    prev = node[0]
    nex = node[3]

    nex  ? nex[0] = prev : @head = prev
    prev ? prev[3] = nex : @tail = nex

    node[2]
  end

  def clear
    @data.clear
    @head = @tail = nil
  end

  def count
    @data.size
  end

  # for cache validation only, ensures all is sound
  def valid?
    count = 0
    self.each_unsafe do |k,v|
      return false if @data[k][2] != v
      count += 1
    end
    count == @data.size
  end

  protected

  def add_to_head(key,val)
    if @head.nil?
      @tail = @head = [nil,key,val,nil]
    else
      node = [@head,key,val,nil]
      @head = @head[3] = node
    end
  end

  def move_to_head(node)
    return unless @head && node[1] != @head[1]

    prev = node[0]
    nex = node[3]

    if prev
      prev[3] = nex
    else
      @tail = nex
    end

    if nex
      nex[0] = prev
    end

    @head[3] = node
    node[0] = @head
    @head = node
  end

  def pop_tail
    if @data.length > @max_size
      @data.delete(@tail[1])
      @tail = @tail[3]
      @tail[0] = nil
      true
    end
  end
end
