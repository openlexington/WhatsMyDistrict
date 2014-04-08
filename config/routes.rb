require 'sinatra/twitter-bootstrap'
require 'sass'
require 'airbrake'
require 'rack-flash'

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
  require 'street_types.rb'
  use SassEngine
  enable :sessions
  use Rack::Flash
  register Sinatra::Twitter::Bootstrap::Assets

  configure :production do
    Airbrake.configure do |config|
      config.api_key = "16c86611790122f558f3467f09bdcc4f"
    end
    use Airbrake::Rack
    enable :raise_errors
  end

  get '/' do
    haml :index
  end

  get '/results' do
    @address = params[:address].strip
    geocode = get_geocode(@address + " Lexington KY")
    unless geocode
      flash[:error] = 'We were unable to locate that address.  Please make sure that you have entered it correctly.'
      redirect to('/')
    end
    @address_split = split_address(@address)
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
    @hospitals = Hospitals.all_for_geocode(geocode)
    haml :results
  end

  get '/cookies' do
    flash[:error] = "testing flash"
    session.map do |k, v|
      "#{k} = #{v}"
    end.join('<br/>')
  end

  private

  def get_geocode address
    geocode_results = Geocoder.search(address)
    if geocode_results.first.types.include?('street_address')
      location = geocode_results.first.geometry['location']
      Geocode.new(location['lat'], location['lng'])
    end
  end

  # return an array of the address split by spaces?
  def split_address(address)
    ary = address.split(/\s+/)
    number = ary.shift
    street_type = (ary.pop || '').downcase.to_sym
    street_name = ary.join(' ')
    if StreetTypes::STREET_TYPES.key?(street_type)
      street_type = StreetTypes::STREET_TYPES[street_type]
    end
    [number, street_name.upcase, street_type.to_s.upcase]
  end
end
