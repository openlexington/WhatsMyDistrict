require_relative 'school_district'

class MiddleSchoolDistrict < SchoolDistrict
  def self.table_name
    'middle'
  end
end
