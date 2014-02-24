class DatabaseModel
  DB = Sequel.postgres(ENV['WMD_DB_NAME'], user: ENV['WMD_DB_USER'],
    host: ENV['WMD_DB_HOST'], password: ENV['WMD_DB_PASSWD'])

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
