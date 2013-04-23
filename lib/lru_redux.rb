module LruRedux
  def self.is_19?
    major,minor = RUBY_VERSION.split(".").map{|a| a.to_i}
    major > 1 || (major == 1 && minor > 8)
  end
end

require "lru_redux/version"
if LruRedux.is_19?
  require "lru_redux/cache19"
else
  require "lru_redux/cache"
end
require "lru_redux/thread_safe_cache"
