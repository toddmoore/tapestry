require 'json'

task :deploy => %w(deploy:rsync deploy:nginx)

namespace :deploy do
  # Get a json description of the servers in an environment
  def json_for(environment, options)
    args = options.map { |k,v| "--#{k} #{v}" }.join " "
    JSON.parse `dew #{args} env show -j #{environment}`.gsub(/^\*\*\*.*$/, '')
  end

  # Get the ssh commandline arguments to connect to an instance of an env
  # TODO grab these from dew
  def ssh_args_for(environment, options)
    instance = options.has_key?(:instance) ? options.delete(:instance) : 1
    #args = options.map { |k,v| "--#{k} #{v}" }.join " "
    #ssh_args = `dew #{args} env ssh -p -i #{instance} #{environment}`.gsub(/^\*\*\*.*$/, '').gsub("\n", " ")
    #ssh_args.gsub /([^ @]+)@\d+\.\d+\./, "-l #{$1}"
    #ssh_args
    "-l ubuntu -i #{ENV['HOME']}/.dew/accounts/keys/#{options[:account]}/#{options[:region]}/devops.pem"
  end

  desc "Rsync the compiled files"
  task :rsync do
    servers = json_for('live-web-uat', :account => "system-test", :region => "us-east-1")
    servers.each_with_index do |server, i|
      ssh_args = ssh_args_for 'live-web-uat', :account => "system-test", :region => "us-east-1", :instance => (i + 1)
      puts "Syncing to server #{server['public_ip']}"
      command = "rsync -avz -e \"ssh #{ssh_args}\" compiled/ #{server['public_ip']}:/var/www/playup-live-web/public"
      puts command
      system command
    end
  end

  desc "Update nginx config"
  task :nginx do
    servers = json_for('live-web-uat', :account => "system-test", :region => "us-east-1")
    servers.each_with_index do |server, i|
      ssh_args = ssh_args_for 'live-web-uat', :account => "system-test", :region => "us-east-1", :instance => (i + 1)
      puts "Updating nginx config on #{server['public_ip']}"
      command = "rsync -avz -e \"ssh #{ssh_args}\" config/nginx.conf #{server['public_ip']}:/var/www/playup-live-web/"
      puts command
      system command
      command = "ssh #{ssh_args} #{server['public_ip']} sudo nginx -s reload"
      puts command
      system command
    end
  end
end
