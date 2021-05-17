require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/namespace'
require 'pry'

set :database, 'sqlite3:db/lists.sqlite3'

require './models'

get '/' do
  List.all.to_json
end

namespace '/api/v1' do
  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
    end

    def json_params
      JSON.parse(request.body.read)
    rescue StandardError => e
      halt 400, { message: e }.to_json
    end
  end

  before do
    content_type 'application/json'
  end

  get '/lists' do
    List.all.to_json
  end

  get '/lists/:id' do |id|
    List.find_by(id: id).to_json
  end

  post '/lists' do
    list = List.new(json_params)
    if list.save
      response.headers['Location'] = "#{base_url}/api/v1/lists/#{list.id}"
      status 201
      body({ message: 'New item was added' }.to_json)
    else
      status 422
      body list.to_json
    end
  end
end
