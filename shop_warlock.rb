require 'sinatra'

$:.unshift File.expand_path('../lib', __FILE__)
require 'item'

error Neopets::Item::ItemNotFound do
  "Item not found"
end

get '/items/:item_name' do |item_name|
  @item = Item.fetch(item_name)
  "<img src='#{@item.image_url}' /><br/> Shop ID: #{@item.shop_id}<br/> #{@item.timestamps.inspect}"
end

