require 'sinatra'

$:.unshift File.expand_path('../lib', __FILE__)
require 'item'

error Neopets::Item::ItemNotFound do
  "Item not found"
end

get '/items/:item_name' do |item_name|
  @item = Item.fetch(item_name)
  haml :item
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

