class Geocode
  attr_reader :latitude, :longitude

  def initialize lat, lng
    @latitude = lat
    @longitude = lng
  end

  def to_point
    "POINT(#{@longitude.to_s} #{@latitude.to_s})"
  end
end
