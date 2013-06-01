class DistrictApp < Sinatra::Base

  get '/' do
    erb :index
  end
end
