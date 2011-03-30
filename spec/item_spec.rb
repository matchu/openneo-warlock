require 'spec_helper'
require 'item'

require 'timecop'

describe Item do
  it "has seemingly random but reproducable timestamps" do
    Timecop.freeze(2011, 3, 30, 1, 2, 3) do
      egg = Item.new 'Blue Draik Egg'
      egg.timestamps.should == [114, 310, 345, 442, 517, 680, 697, 808, 946,
        966, 1133, 1280]

      lipstick = Item.new 'Blue Lipstick'
      lipstick.timestamps.should ==  [79, 197, 246, 328, 421, 496, 528, 544,
        548, 667, 683, 724, 773, 948, 974, 981, 991, 1037, 1045, 1075, 1368,
        1378]
    end
  end
end

