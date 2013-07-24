require_relative 'database_model'

class SenateDistrict < DatabaseModel
  attr_accessor :district, :rep

  def self.table_name
    'senate'
  end

  def self.first_for_geocode geocode
    result = get_first_result("SELECT district, rep FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    SenateDistrict.new(result)
  end
end
