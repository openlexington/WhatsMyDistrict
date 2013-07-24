require_relative 'database_model'

class ElementarySchoolDistrict < DatabaseModel
  attr_accessor :name

  def self.table_name
    'elementary'
  end

  def self.first_for_geocode geocode
    result = get_first_result("SELECT name FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    ElementarySchoolDistrict.new(result)
  end
end
