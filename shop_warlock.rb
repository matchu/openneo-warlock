require 'compass'
require 'sinatra'
require 'haml'

$:.unshift File.expand_path('../lib', __FILE__)
require 'item'

set :root, File.dirname(__FILE__)
set :haml, :format => :html5

configure do
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

error Neopets::Item::ItemNotFound do
  "Item not found"
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
end

get '/' do
  haml :item, :layout => :item_layout
end

['/items/:name', '/items'].each do |path|
  get path do
    @item = Item.fetch(params[:name]) if params[:name] && !params[:name].empty?
    haml :item, :layout => :item_layout
  end
end

helpers do
  # Formats integer representing the second of the day, e.g. 123, to the HH:MM
  # format, e.g. 02:03
  def format_timestamp(timestamp)
    [timestamp / 60, timestamp % 60].map do |integer|
      integer.to_s.rjust(2, '0')
    end.join(':')
  end
end

