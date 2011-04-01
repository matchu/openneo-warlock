require 'sinatra/base'

class CacheHelper
  module Sinatra
    module Helpers
      def cache(name, options = {})
        if cache = read_fragment(name, options)
          cache
        else
          tmp = capture_haml(&Proc.new)
          write_fragment(name, tmp, options)
        end
      end

      def read_fragment(name, options = {})
        cache_file = Sinatra::fragment_path(name)
        now = Time.now
        if File.file?(cache_file)
          if options[:max_age]
            (current_age = (now - File.mtime(cache_file)).to_i / 60)
            puts "Fragment for '#{name}' is #{current_age} minutes old."
            return false if (current_age > options[:max_age])
          end
          return File.read(cache_file)
        end
        false
      end

      def write_fragment(name, buf, options = {})
        cache_file = Sinatra::fragment_path(name)
        f = File.new(cache_file, "w+")
        f.write(buf)
        f.close
        puts "Fragment written for '#{name}'"
        buf
      end
    end

    def self.fragment_exists?(name)
      File.file?(fragment_path(name))
    end

    def self.registered(app)
      app.helpers CacheHelper::Sinatra::Helpers
    end

    protected

    def self.fragment_path(name)
      File.join(CACHE_ROOT, 'tmp', "#{name}.cache")
    end
  end
end

Sinatra.register CacheHelper::Sinatra

