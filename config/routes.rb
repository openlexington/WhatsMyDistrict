class DistrictApp < Sinatra::Base

  get '/' do
    erb :index
  end

  post '/search/:query' do
    #
  end

  get '/results' do
    #
  end
end
