require 'sinatra'
require 'rack'
require 'json'
require 'httparty'
require 'dotenv'

Dotenv.load

configure do
	set :erb, layout: :layout
end

def load_user(username)
  data = HTTParty.get("https://api.producthunt.com/v1/users/#{username}?exclude[]=relationships",
                      headers: {
                        'Authorization' => "Bearer #{ENV['PH_API_KEY']}"
                      }
    )

  if data.code == 200
    return data['user']
  else
    return false
  end
end

get '/user/:username' do
  content_type 'text/javascript'
  @user = load_user(params[:username])
  erb :index
end

# get '/frame/:username' do
#   @user = load_user(params[:username])
#   erb :frame
# end