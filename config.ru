# frozen_string_literal: true

require 'json'
require 'rack/app'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

# Top-Level Rack Application
class App < Rack::App
  headers 'Access-Control-Allow-Origin' => '*'

  serializer do |obj|
    if obj.is_a?(String)
      obj
    else
      JSON.dump(obj)
    end
  end

  payload do
    parser do
      accept :json, :www_form_urlencoded
      reject_unsupported_media_types
    end
  end

  error StandardError, NoMethodError do |ex|
    { error: ex.message }
  end

  desc 'Microprofile Health endpoint'
  get '/health' do
    response.headers['Content-Type'] = 'application/json'

    { status: 'UP' }
  end

  desc 'Version endpoint'
  get '/version' do
    response.status = 200
    response.headers['Content-Type'] = 'application/json'

    { application: 'Puma Rack App', version: '1.0.0' }
  end

  require_relative 'app_users'
  mount App::Users, to: '/'
end

run App
