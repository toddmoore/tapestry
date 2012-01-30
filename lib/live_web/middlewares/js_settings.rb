module LiveWeb
  module Middlewares
    class JsSettings
      def initialize(app)
        @app = app
      end

      def ci_facebook_app
        require 'yaml'
        ci_config = YAML.load_file File.join(LiveWeb.root, "config", "ci_config.yml")
        ci_config['facebook']['app_id']
      end

      def js_settings_content
        js_settings_file = File.join(LiveWeb.root, "config/js_settings/#{ENV['JS_ENV'] || ENV['RACK_ENV']}.js")
        unless File.exists?(js_settings_file)
          js_settings_file = File.join(LiveWeb.root, "config/js_settings/development.js")
        end
        settings = File.read(js_settings_file)

        # ensure the DEV Facebook App is used
        if defined?(Cucumber)
          settings.gsub! /(.*appId\s*:\s*)('|")\d*('|")(.*)/ do
            "#{$1}'#{ci_facebook_app}'#{$4}}"
          end
        end
        settings
      end

      def call(env)
        if env['PATH_INFO'] == '/javascripts/settings.js'
          [200, { 'Content-Type' => 'application/javascript' }, [js_settings_content]]
        else
          @app.call(env)
        end
      end
    end
  end
end
