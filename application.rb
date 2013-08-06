$:.unshift File.join(__FILE__, "../config")

require 'sinatra/base'
require 'bundler/setup'
require 'routes'
require 'app_config'
require 'airbrake'

Dir.glob(File.join("models/**")) {|f| require "./#{f}"}

class DistrictApp < Sinatra::Base
  set :app_file, __FILE__
  set :views, settings.root + '/views'

  helpers do
    def word_splitter str
      return unless str
      str.split.map {|piece| piece.capitalize}.join(' ')
    end
  end
end
