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
    if params[:name] && !params[:name].empty?
      @item = Item.fetch(params[:name])
      @timestamps = @item.timestamps.map { |seconds| parse_timestamp(seconds) }
    end
    haml :item, :layout => :item_layout
  end
end

def parse_timestamp(seconds)
  [seconds / 60, seconds % 60]
end

helpers do
  def capitalize(phrase)
    phrase.split(' ').map { |word| word[0].upcase + word[1..-1] }.join(' ')
  end

  # Formats integer representing the second of the day, e.g. 123, to the HH:MM
  # format, e.g. 02:03
  def format_timestamp(timestamp)
    timestamp.map do |integer|
      integer.to_s.rjust(2, '0')
    end.join(':')
  end

  def timestamp_classname(timestamp)
    hour = timestamp[0]
    minute = timestamp[1]
    "h#{hour} m#{minute}"
  end

  def timestamp_expiry_stylesheet
    now = Time.now

    expired_classes = []
    0.upto(now.hour - 1) do |expired_hour|
      expired_classes << ".h#{expired_hour}"
    end

    0.upto(now.min - 1) do |expired_min|
      expired_classes << ".h#{now.hour}.m#{expired_min}"
    end

    expired_query = expired_classes.join ','

    "<style type='text/css'>#{expired_query}{background:#aaa}</style>"
  end
end

