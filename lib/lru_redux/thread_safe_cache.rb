require 'thread'
require 'monitor'

class LruRedux::ThreadSafeCache < LruRedux::Cache
  include MonitorMixin
  def initialize(size)
    super(size)
  end

  def self.synchronize(*methods)
    methods.each do |method|
      define_method method do |*args, &blk|
        synchronize do
          super(*args,&blk)
        end
      end
    end
  end

  synchronize :[], :[]=, :each, :to_a, :delete, :count, :valid?, :max_size, :fetch, :getset

end
