require 'thread'
class LruRedux::ThreadSafeCache < LruRedux::Cache
  def initialize(size)
    @lock = Mutex.new
    super(size)
  end

  def self.synchronize(*methods)
    methods.each do |method|
      define_method method do |*args, &blk|
      @lock.synchronize do
          super(*args,&blk)
        end
      end
    end
  end

  synchronize :[], :[]=, :each, :to_a, :delete, :count, :valid?, :max_size

end
