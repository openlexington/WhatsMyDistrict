require_relative 'database_model'

class NeighborhoodAssociation < DatabaseModel
  attr_accessor :assoc_name

  def self.table_name
    'neighborhood_assoc'
  end

  def self.all_for_geocode geocode
    results = get_results("SELECT assoc_name FROM #{table_name} WHERE ST_Within(ST_SetSRID(ST_GeomFromText('#{geocode.to_point}'),4269),geom);")
    results.map {|result| NeighborhoodAssociation.new(result)}
  rescue Sequel::DatabaseError
    []
  end
end
