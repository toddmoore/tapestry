require 'tilt'
require 'erb'

module LiveWeb
  class Template
    class Context
      def javascript_include_tag(source, options = {})
        if options.has_key? :debug
          debug = options.delete :debug
        else
          debug = LiveWeb.development?
        end

        if debug && asset = LiveWeb.assets[source]
          asset.to_a.map { |dep|
            next if dep.logical_path == source
            javascript_include_tag dep, :debug => false
          }.join("\n")
        else
          source = source.logical_path if source.respond_to? :logical_path
          if source[0] == ?/
            path = source
          else
            path = LiveWeb.assets.path(source, LiveWeb.assets.caching?, "assets")
          end
          "<script src=\"#{path}\"></script>"
        end
      end

      def stylesheet_link_tag(source, options = {})
        if options.has_key? :debug
          debug = options.delete :debug
        else
          debug = LiveWeb.development?
        end

        if debug && asset = LiveWeb.assets[source]
          asset.to_a.map { |dep|
            next if dep.logical_path == source
            stylesheet_link_tag dep, :debug => false
          }.join("\n")
        else
          source = source.logical_path if source.respond_to? :logical_path
          if source[0] == ?/
            path = source
          else
            path = LiveWeb.assets.path(source, LiveWeb.assets.caching?, "assets")
          end
          "<link href=\"#{path}\" rel=\"stylesheet\">"
        end
      end

      def google_analytics_profile
        LiveWeb.settings.google_analytics_profile_id
      end

      def google_analytics_domain
        LiveWeb.settings.google_analytics_domain || 'auto'
      end
    end

    def initialize(path)
      @template = Tilt.new path
    end

    def render
      @template.render(Context.new)
    end

    def write_to(path)
      File.open(path, "w") { |f| f << render }
    end
  end
end
