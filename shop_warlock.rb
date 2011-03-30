require 'sinatra'

$:.unshift File.expand_path('../lib', __FILE__)
require 'item'

set :haml, :format => :html5

error Neopets::Item::ItemNotFound do
  "Item not found"
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

