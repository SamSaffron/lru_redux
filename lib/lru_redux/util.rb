require 'util/safe_sync'

require 'util/safe_sync_jruby' if
    RUBY_PLATFORM == 'java' && JRUBY_VERSION < '9.0'