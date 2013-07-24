require_relative 'school_district'

class HighSchoolDistrict < SchoolDistrict
  def self.table_name
    'high'
  end
end
