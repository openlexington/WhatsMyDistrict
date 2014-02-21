class DatabaseModel
  DB = Sequel.postgres('districts', user: 'postgres', host: 'localhost')

  def initialize attributes
    attributes.each {|k,v| self.send("#{k}=", v) }
  end

  def self.get_results query
    DB[query] || []
  rescue Sequel::DatabaseError
    []
  end

  def self.get_first_result query
    get_results(query).first || {}
  rescue Sequel::DatabaseError
    {}
  end
end
