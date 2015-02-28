require 'monitor'

class LruRedux::ThreadSafeCache < LruRedux::Cache
  include MonitorMixin

  def initialize(max_size)
    super(max_size)
  end

  def max_size=(size)
    synchronize do
      super(size)
    end
  end

  def getset(key)
    synchronize do
      super(key)
    end
  end

  def fetch(key)
    synchronize do
      super(key)
    end
  end

  def [](key)
    synchronize do
      super(key)
    end
  end

  def []=(key, value)
    synchronize do
      super(key, value)
    end
  end

  def each
    synchronize do
      super
    end
  end

  def to_a
    synchronize do
      super
    end
  end

  def delete(key)
    synchronize do
      super(key)
    end
  end

  def clear
    synchronize do
      super
    end
  end

  def count
    synchronize do
      super
    end
  end

  def valid?
    synchronize do
      super
    end
  end
end
