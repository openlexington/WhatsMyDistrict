$:.unshift File.join(__FILE__, "../config")

require 'sinatra/base'
require 'bundler/setup'
require 'routes'
require 'app_config'
require 'airbrake'
require 'dotenv'

Dotenv.load

Dir.glob(File.join("models/**")) {|f| require "./#{f}"}

ROMAN_NOOMS = ["I", "II", "III", "IV", "V"]

class DistrictApp < Sinatra::Base
  set :app_file, __FILE__
  set :views, settings.root + '/views'

  helpers do
    def word_splitter str
      return unless str
      str.split.map do |piece|
        ROMAN_NOOMS.include?(piece) ? piece : piece.capitalize
      end.join(' ')
    end

    def flash_types
      [:success, :notice, :warning, :error]
    end
  end
end
