require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end


get '/' do
  csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  erb :index
end

get '/about' do
  erb :about
end

get '/new' do
  erb :new
end

post '/recipes' do
  csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @name = params[:name]
  @description = params[:descr]
  @rating = params[:rate]
  @prep_time = params[:prep_time]
  "#{@name} : #{@description} ( #{@rating} / 5 ) - #{@prep_time}"
  @recipe = Recipe.new(@name, @description, @rating, @prep_time, false, 'N/A')
  @cookbook.add_recipe(@recipe)
  redirect '/'
end

get '/destroy_:idx' do
  csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @cookbook.remove_recipe(params[:idx].to_i)
  redirect '/'
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end

helpers do
  def a_with_index(options = {})
    '<a href="/destroy_' + options[:index].to_s + '"> DESTROY </a></li>'
  end
end
