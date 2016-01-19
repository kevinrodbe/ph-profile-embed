require 'sinatra'
require 'rack'
require 'json'
require 'httparty'
require 'dotenv' if development?

Dotenv.load if development?

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

get '/' do
  redirec 'http://karlcoelho.github.io/ph-profile-embed'
end

get '/user/:username' do
  content_type 'text/javascript'
  response['Access-Control-Allow-Origin'] = '*'
  @user = load_user(params[:username])
  erb :index
end

get '/preview/:username' do
  @user = params[:username]
  erb :preview
end