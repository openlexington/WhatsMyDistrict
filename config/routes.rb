require 'sinatra/twitter-bootstrap'
require 'sass'

class SassEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/../assets/stylesheets'

  get '/scss/*.css' do
    filename = params[:splat].first
    scss filename.to_sym
  end
end

class DistrictApp < Sinatra::Base
  require 'geocoder'
  require 'sequel'
  use SassEngine
  register Sinatra::Twitter::Bootstrap::Assets

  get '/' do
    haml :index
  end

  get '/results' do
    @address = params[:address].strip
    geocode = get_geocode(@address + " Lexington KY")
    @council = CouncilDistrict.first_for_geocode(geocode)
    @magistrate = MagistrateDistrict.first_for_geocode(geocode)
    @school_board = SchoolBoardDistrict.first_for_geocode(geocode)
    @elem_school = ElementarySchoolDistrict.first_for_geocode(geocode)
    @middle_school = MiddleSchoolDistrict.first_for_geocode(geocode)
    @high_school = HighSchoolDistrict.first_for_geocode(geocode)
    @senate = SenateDistrict.first_for_geocode(geocode)
    @house = HouseDistrict.first_for_geocode(geocode)
    @voting = VotingDistrict.first_for_geocode(geocode)
    @neighborhoods = NeighborhoodAssociation.all_for_geocode(geocode)
    haml :results
  end

  private

  def get_geocode address
    geocode_results = Geocoder.search(address)
    location = geocode_results.first.geometry['location']
    Geocode.new(location['lat'], location['lng'])
  end
end
