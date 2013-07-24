require_relative 'database_model'

class CouncilDistrict < DatabaseModel
  attr_accessor :district, :rep, :url, :telephone, :email

  def self.table_name
    'council'
  end

  def self.first_for_geocode geocode
    result = get_first_result("SELECT district, rep, url, telephone, email FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    CouncilDistrict.new(result)
  end
end
