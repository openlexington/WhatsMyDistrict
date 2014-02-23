require_relative 'database_model'

class Hospitals < DatabaseModel
  attr_accessor :name, :address


  def self.table_name
    'hospitals'
  end

  def self.all_for_geocode geocode
    results = get_results("SELECT name, address FROM hospitals ORDER BY geom <-> st_setsrid(ST_GeomFromText('#{geocode.to_point}'),4326);")
    results.map {|result| Hospitals.new(result)}
  rescue Sequel::DatabaseError
    []
  end
end
