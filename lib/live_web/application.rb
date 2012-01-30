module LiveWeb
  class App
    def initialize
      @file = Rack::File.new(File.join(LiveWeb.root, "public"))
    end

    def call(env)
      status, headers, body = @file.call(env)
      if status >= 400
        render_template(env)
      else
        [status, headers, body]
      end
    end

    def render_template(env)
      if env["PATH_INFO"] == "/"
        template = Template.new "templates/index.html.erb"
        body = template.render
        [200, { 'Content-Type' => 'text/html' }, [body]]
      else
        [404, { 'Content-Type' => 'text/html' }, ["Not Found"]]
      end
    end
  end
end
