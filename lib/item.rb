require_relative '../vendor/neopets_items/lib/neopets/item'

require 'digest/md5'

class Item < Neopets::Item
  TIMESTAMP_DATE_FORMAT = '%Y%m%d'
  TIMEZONE = TZInfo::Timezone.get('America/Los_Angeles')

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

  protected

  def timestamp_seed
    local_time = TIMEZONE.utc_to_local(Time.now.utc)
    Digest::MD5.hexdigest("#{name} " + local_time.strftime(TIMESTAMP_DATE_FORMAT)).hex
  end
end

