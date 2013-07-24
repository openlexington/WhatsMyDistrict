require_relative 'database_model'

class SchoolDistrict < DatabaseModel
  attr_accessor :sname

  def self.first_for_geocode geocode
    result = get_first_result("SELECT sname FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    SchoolDistrict.new(result)
  end
end
