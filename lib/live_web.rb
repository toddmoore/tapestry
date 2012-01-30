module LiveWeb
  class << self
    def root
      File.join File.dirname(__FILE__), '..'
    end

    attr_writer :environment
    def environment
      @environment ||= ENV['RACK_ENV'] || 'development'
    end

    def development?
      @environment == 'development' or @environment == 'isolation'
    end
  end
end

$: << File.join(LiveWeb.root, 'lib')

require 'kernel'

begin
  require File.join(LiveWeb.root, "config/#{LiveWeb.environment}")
rescue LoadError
  require File.join(LiveWeb.root, "config/development")
end

require 'live_web/template'
require 'live_web/assets'
require 'live_web/application'

require 'live_web/middlewares/js_settings'

