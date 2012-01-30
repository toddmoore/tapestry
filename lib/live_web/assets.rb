require 'sprockets'
require 'uglifier'
require 'sass'

module LiveWeb
  # TODO build our own class LiveWeb::Assets to set this up properly

  class Assets
    def initialize
      @sprockets = Sprockets::Environment.new
      @sprockets.js_compressor = Uglifier.new unless LiveWeb.development?
      @sprockets.append_path File.join(LiveWeb.root, "assets/javascripts")
      @sprockets.append_path File.join(LiveWeb.root, "assets/stylesheets")
    end

    def caching?
      not LiveWeb.development?
    end

    def call(env)
      @sprockets.call env
    end

    def [](source)
      @sprockets[source]
    end

    def path(*args)
      silence_warnings { @sprockets.path *args }
    end
  end

  def self.assets
    @assets ||= Assets.new
  end
end
