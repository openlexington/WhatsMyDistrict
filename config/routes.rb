class DistrictApp < Sinatra::Base
  require 'geocoder'
  require 'sequel'

  DB = Sequel.postgres('blake', user: 'blake', host: 'localhost')

  get '/' do
    erb :index
  end

  get '/results' do
    @address = params[:address]
    geocode_results = Geocoder.search(@address + " Lexington KY")
    @lat = geocode_results.first.geometry['location']['lat']
    @lng = geocode_results.first.geometry['location']['lng']

    @council = get_council(@lat, @lng)
    @magistrate = get_magistrate(@lat, @lng)
    @school_board = get_school_board(@lat, @lng)
    @elem_school = get_elementary_school(@lat, @lng)
    @middle_school = get_middle_school(@lat, @lng)
    @high_school = get_high_school(@lat, @lng)
    @senate = get_senate(@lat, @lng)
    @house = get_house(@lat, @lng)
    @voting = get_voting(@lat, @lng)
    @neighborhood = get_neighborhood(@lat, @lng)
    if @neighborhood.nil? || @neighborhood.empty?
      @neighborhood = [{assoc_name: ''}]
    end

    erb :results
  end

  private

  def get_council lat, lng
    get_first_result("SELECT district,rep,url,telephone,email from council where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_magistrate lat, lng
    get_first_result("SELECT district,rep from magistrate where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_school_board lat, lng
    get_first_result("SELECT district,rep from school_board where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_elementary_school lat, lng
    get_first_result("SELECT name from elementary where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_middle_school lat, lng
    get_first_result("SELECT sname from middle where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_high_school lat, lng
    get_first_result("SELECT sname from high where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_senate lat, lng
    get_first_result("SELECT district,rep from senate where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_house lat, lng
    get_first_result("SELECT district,rep from house where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_voting lat, lng
    get_first_result("SELECT name from voting where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_neighborhood lat, lng
    get_first_result("SELECT assoc_name from neighborhood_assoc where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{lng.to_s} #{lat.to_s})'),4269),geom);")
  end

  def get_first_result query
    DB[query].first
  rescue Sequel::DatabaseError
    {}
  end
end
