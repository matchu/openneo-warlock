require 'spec_helper'
require 'neopets/item'

describe Neopets::Item do
  it "initializes with its name" do
    item = Neopets::Item.new 'Blue Draik Egg'
    item.name.should == 'Blue Draik Egg'
    item = Neopets::Item.new 'Red Draik Egg'
    item.name.should == 'Red Draik Egg'
  end

  describe "#load!" do
    context "stubbed" do
      before :each do
        @item = Neopets::Item.new 'Blue Draik Egg'
        response = mock(HTTParty::Response)
        response.stub!(:body).and_return(fixture_html('blue_draik_egg.html'))
        Neopets::Item.stub!(:get).with('http://www.neopets.com/search.phtml?selected_type=object&string=Blue%20Draik%20Egg').and_return(response)
        @item.load!
      end

      it "retrieves the image URL" do
        @item.image_url.should == 'http://images.neopets.com/items/draik_egg_blue.gif'
      end

      it "retrieves the shop ID" do
        @item.shop_id.should == 56
      end
    end

    context "live" do
      before :all do
        @item = Neopets::Item.new 'Blue Lipstick'
        @item.load!
      end

      it "retrieves the image URL" do
        @item.image_url.should == 'http://images.neopets.com/items/bluelipstick.gif'
      end

      it "retrieves the shop ID" do
        @item.shop_id.should == 5
      end
    end

    context "does not exist" do
      it "should raise an error if the item does not exist" do
        item = Neopets::Item.new 'Dfjkgfjdkgljfk Lipstick'
        lambda { item.load! }.should raise_error(Neopets::Item::ItemNotFound)
      end
    end
  end

  describe "::fetch" do
    it "should be a shorthand for initialization and loading" do
      item = mock(Neopets::Item)
      item.should_receive(:load!)
      Neopets::Item.stub!(:new).with('Blue Lipstick').and_return(item)
      Neopets::Item.fetch('Blue Lipstick')
    end
  end
end

