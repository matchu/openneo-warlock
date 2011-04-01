require 'compass'
require 'sinatra'
require 'haml'

$:.unshift File.expand_path('../lib', __FILE__)
require 'item'
require 'cache_helper'

set :root, File.dirname(__FILE__)
set :haml, :format => :html5

CACHE_ROOT = Sinatra::Application.root

TIMEZONE = TZInfo::Timezone.get('America/Los_Angeles')

configure do
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

error Neopets::Item::ItemNotFound do
  haml :item_not_found, :layout => :item_layout
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
    @item_name = params[:name]
    @item = Item.new(@item_name)
    if @item_name && !@item_name.empty?
      if !item_cached?(@item)
        @item.load!
        @timestamps = @item.timestamps.map { |seconds| parse_timestamp(seconds) }
      end
    else
      @item = nil
    end
    haml :item, :layout => :item_layout
  end
end

def item_cached?(item)
  CacheHelper::Sinatra::fragment_exists?(item.key_today)
end

def parse_timestamp(seconds)
  [seconds / 60, seconds % 60]
end

helpers do
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
    now = TIMEZONE.utc_to_local(Time.now.utc)

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

