desc "Compile the whole site into compiled/"
task :compile => %w(compile:clean compile:templates compile:assets compile:public compile:settings)

namespace :compile do
  def output_dir(*extra_paths)
    File.join *[LiveWeb.root, "compiled"].+(extra_paths)
  end

  def ensure_output_directory
    Dir.mkdir output_dir unless File.directory? output_dir
  end

  desc "Clean out the compiled output directory"
  task :clean => :environment do
    `rm -rf #{output_dir}`
  end

  desc "Compile HTML templates"
  task :templates => :environment do
    ensure_output_directory
    # TODO make this generic and compile all templates
    #      something like...
    # Dir.glob "templates/**/*.html.*" do |path|
    #   LiveWeb::Template.new(path).write_to path.replace(/^templates/, "compiled")
    # end

    template_files = %w(index.html.erb)
    template_files.each do |template_file|
      puts "Compiling #{template_file}"
      template = LiveWeb::Template.new(File.join LiveWeb.root, "templates/#{template_file}")
      template.write_to output_dir(template_file.gsub(/\.erb/, ''))
    end
  end

  desc "Compile all sprockets-controlled assets"
  task :assets => :environment do
    ensure_output_directory
    # TODO make this one generic too
    javascripts = %w(live_web vendor modernizr-2.0.6).map { |js| "#{js}.js" }
    stylesheets = %w(playup-live).map { |css| "#{css}.css" }
    assets = javascripts + stylesheets
    assets.map { |asset| LiveWeb.assets[asset] }.each do |asset|
      FileUtils.mkdir_p output_dir("assets") unless File.directory? output_dir("assets")
      puts "Compiling #{asset.logical_path}"
      asset.write_to output_dir("assets", asset.digest_path)
    end
  end

  desc "Copy all files from public"
  task :public => :environment do
    ensure_output_directory
    FileUtils.cp_r "public/.", output_dir, :preserve => true, :verbose => true
  end

  task :settings => :environment do
    FileUtils.mkdir_p output_dir("javascripts")
    FileUtils.cp File.join(LiveWeb.root, "config/js_settings/#{LiveWeb.environment}.js"), output_dir("javascripts/settings.js")
  end
end

