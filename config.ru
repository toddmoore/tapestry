#!/usr/bin/env ruby

ENV['RACK_ENV'] ||= 'development'

require './lib/live_web'

require 'rack'
require 'rack/reverse_proxy'

use Rack::Logger
use LiveWeb::Middlewares::JsSettings

map "/assets" do
  run LiveWeb.assets
end

map "/" do
  run LiveWeb::App.new
end
