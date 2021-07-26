# frozen_string_literal: true

require 'rack/app'
require 'mongoid'

# User MongoDB Model
class User
  include Mongoid::Document

  field :username, type: String
  field :email, type: String
end

# Nested Rack Application for Users endpoints
class App::Users < Rack::App
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
    response.status = 500
    { error: ex.message }
  end

  desc 'Get all Users'
  get '/api/users' do
    response.headers['Content-Type'] = 'application/json'

    User.all.to_json
  end

  desc 'Create a new User'
  post '/api/users' do
    user = User.create!(payload)

    response.status = 201
    response.headers['Content-Type'] = 'application/json'

    user.to_json
  end

  desc 'Find User by _id'
  get '/api/users/:id' do
    user = User.find(params['id'])

    response.headers['Content-Type'] = 'application/json'
    user.to_json
  rescue Mongoid::Errors::DocumentNotFound
    response.status = 404
    ''
  end

  desc 'Delete User by _id'
  delete '/api/users/:id' do
    response.headers['Content-Type'] = 'application/json'

    user = User.find(params['id'])
    { success: user.delete }

  rescue Mongoid::Errors::DocumentNotFound
    response.status = 404
    ''
  end
end
