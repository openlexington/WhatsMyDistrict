$:.unshift File.join(__FILE__, "../config")

require 'sinatra/base'
require 'bundler/setup'
require 'routes'
require 'app_config'

Dir.glob(File.join("models/**")) {|f| require "./#{f}"}

class DistrictApp < Sinatra::Base
  set :app_file, __FILE__
  set :views, settings.root + '/views'
end
