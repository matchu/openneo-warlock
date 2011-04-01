require 'uri'

require 'rubygems'
require 'httparty'
require 'nokogiri'

module Neopets
  class Item
    include HTTParty

    attr_reader :image_url, :name, :shop_id

    def initialize(name)
      @name = name
    end

    def load!
      html_doc = Nokogiri::HTML(load_html!)
      parse_html!(html_doc)
    end

    def self.fetch(name)
      item = new(name)
      item.load!
      item
    end

    protected

    def load_html!
      body = self.class.get(search_url).body
      puts "Loaded #{search_url}"
      body
    end

    def parameterized_name
      URI.escape(name)
    end

    def parse_html!(html_doc)
      content = html_doc.at_css('td.contentModuleContent')
      shop_id_field = content.at_css('input[name=obj_type]')
      unless shop_id_field
        raise ItemNotFound, "Could not find any item called #{@name.inspect}"
      end
      @shop_id = shop_id_field['value'].to_i
      img = content.at_css('img')
      @image_url = img['src']
    end

    def search_url
      "http://www.neopets.com/search.phtml?selected_type=object&string=#{parameterized_name}"
    end

    class ItemNotFound < RuntimeError;end
  end
end

