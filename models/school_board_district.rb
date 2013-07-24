require_relative 'database_model'

class SchoolBoardDistrict < DatabaseModel
  attr_accessor :district, :rep

  def self.table_name
    'school_board'
  end

  def self.first_for_geocode geocode
    result = get_first_result("SELECT district, rep FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    SchoolBoardDistrict.new(result)
  end
end
