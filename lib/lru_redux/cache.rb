class LruRedux::Cache

  # for high efficiency nodes in double linked list are stored in arrays
  # [prev,key,val,next]

  def initialize(max_size)
    @max_size = max_size
    @data = {}
    @head = nil
    @tail = nil
  end

  def [](key)
    node = @data[key]
    if node
      move_to_head(node)
      node.value
    end
  end

  def []=(key,val)
    node = @data[key]
    if node
      move_to_head(node)
      node.value = val
    else
      pop_tail
      @data[key] = add_to_head(key,val)
    end
    val
  end

  def each
    if n = @head
      while n
        yield [n.key, n.value]
        n = n.prev
      end
    end
  end

  # used further up the chain, non thread safe each
  alias_method :each_unsafe, :each

  def to_a
    a = []
    self.each_unsafe do |k,v|
      a << [k,v]
    end
    a
  end

  def delete(k)
    node = @data[k]
    if node
      @data.delete(k)
      prev = node.prev
      nex = node.next

      prev.next = nex if prev
      nex.prev = prev if nex
    end
  end

  def clear
    @data.clear
    @head = @tail = nil
  end

  def count
    @data.count
  end

  # for cache validation only, ensures all is sound
  def valid?
    expected = {}
    self.each_unsafe do |k,v|
      expected[k] = v
    end
    expected == @data
  end

  protected

  def add_to_head(key,val)
    if @head.nil?
      @tail = @head = Node.new(key,val,nil,nil)
    else
      node = Node.new(key,val,@head,nil)
      @head = @head.next = node
    end
  end

  def move_to_head(node)
    return unless @head && node != @head

    prev = node.prev
    nex = node.next

    if prev
      prev.next = nex
    else
      @tail = nex
    end

    if nex
      nex.prev = prev
    end

    @head.next = node
    node.prev = @head
    @head = node
  end

  def pop_tail
    if @data.length == @max_size
      @data.delete(@tail.key)
      @tail = @tail.next
      @tail.prev = nil
    end
  end


  class Node
    attr_accessor :key, :value, :next, :prev
    def initialize(key,value,prev,nex)
      @key = key
      @value = value
      @prev = prev
      @next = nex
    end
  end
end
