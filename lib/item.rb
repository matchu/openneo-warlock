require_relative '../vendor/neopets_items/lib/neopets/item'

require 'digest/md5'

class Item < Neopets::Item
  TIMESTAMP_DATE_FORMAT = '%Y%m%d'
  TIMEZONE = TZInfo::Timezone.get('America/Los_Angeles')

  def formal_name
    name.split(' ').map { |word| word[0].upcase + word[1..-1].downcase }.join(' ')
  end

  def timestamps
    unless @timestamps
      @timestamps = []
      generator = Random.new(timestamp_seed)
      generator.rand(10..50).times do
        timestamp = nil
        while !timestamp || @timestamps.include?(timestamp)
          timestamp = generator.rand(24*60)
        end
        @timestamps << timestamp
      end
      @timestamps.sort!
    end
    @timestamps
  end

  def key_today
    # Use a timezoned timestamp here to ensure that our date is based on NST,
    # not UTC
    local_time = TIMEZONE.utc_to_local(Time.now.utc)
    "#{formal_name} " + local_time.strftime(TIMESTAMP_DATE_FORMAT)
  end

  protected

  def timestamp_seed
    Digest::MD5.hexdigest(key_today).hex
  end
end

