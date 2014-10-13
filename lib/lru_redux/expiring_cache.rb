class LruRedux::ExpiringCache < LruRedux::Cache
  def initialize(max_size, expires_in)
    super(max_size)
    @expires_in = expires_in
    @expire_times = {}
  end

  def getset(key)
    evict(key) if expired?(key)
    super(key) do
      @expire_times[key] = Time.now + @expires_in
      yield
    end
  end

  def fetch(key)
    evict(key) if expired?(key)
    super
  end

  def []=(key, val)
    @expire_times[key] = Time.now + @expires_in
    super
  end

  def [](key)
    evict(key) if expired?(key)
    super
  end

  private

  def expired?(key)
    @expire_times.key?(key) && @expire_times[key] < Time.now
  end

  def evict(key)
    @expire_times.delete(key)
    super
  end
end
