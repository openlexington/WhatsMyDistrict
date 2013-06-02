class DistrictApp < Sinatra::Base
  require 'geocoder'
  require 'sequel'

  DB = Sequel.postgres('blake', user: 'blake', host: 'localhost')

  get '/' do
    erb :index
  end

  get '/results' do
    geocode_results = Geocoder.search(params[:address] + " Lexington KY")
    @lat = geocode_results.first.geometry['location']['lat']
    @lng = geocode_results.first.geometry['location']['lng']

    @council = DB["SELECT district,rep,url,telephone,email from council where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @magistrate = DB["SELECT district,rep from magistrate where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @school_board = DB["SELECT district,rep from school_board where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @elem_school = DB["SELECT name from elementary where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @middle_school = DB["SELECT sname from middle where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @high_school = DB["SELECT sname from high where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @senate = DB["SELECT district,rep from senate where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @house = DB["SELECT district,rep from house where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    @voting = DB["SELECT name from voting where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"].first
    neighborhood_results = DB["SELECT assoc_name from neighborhood_assoc where ST_Within(ST_SetSRID(ST_GeomFromText('POINT(#{@lng.to_s} #{@lat.to_s})'),4269),geom);"]
    unless neighborhood_results.empty?
      @neighborhood = neighborhood_results
    else
      @neighborhood = [{assoc_name: ""}]
    end

    erb :results
  end

end
