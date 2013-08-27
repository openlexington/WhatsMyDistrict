require 'sinatra/twitter-bootstrap'
require 'sass'
require 'airbrake'

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
    haml :results
  end

  private

  def get_geocode address
    geocode_results = Geocoder.search(address)
    location = geocode_results.first.geometry['location']
    Geocode.new(location['lat'], location['lng'])
  end

  # return an array of the address split by spaces?
  def split_address(address)
    ary = address.split(' ')
    street_types = {lane:"LN",
    street:"ST",
    drive:"DR",
    road:"RD",
    highway:"HWY",
    cove:"CV",
    avenue:"AVE",
    circle:"CIR",
    court:"CT",
    trail:"TRL",
    way:"WAY",
    boulevard:"BLVD",
    alley:"ALY"}
    number = ary.shift
    street_type = ary.pop
    street_name = ary.join(' ')
    street_type = street_types[street_type.downcase.to_sym]
    [number, street_name.upcase, street_type.upcase]
  end
end
