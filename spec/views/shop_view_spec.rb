require 'spec_helper'
require 'simplecov'
SimpleCov.start 'rails'


describe "Shop page should show shop relevant information" do
  before(:each) do
    @shop = Shop.find(1)
  end
  context "Shop page is found" do
    it "displays correct Shops page" do
      visit "/shops/1"
      expect(page).to have_link("Look this shop up on Yelp")
    end

    it "redirects user to yelp page of shop" do
      visit "/shops/1"
      click_link "Look this shop up on Yelp"
      current_path.should eq(@shop.yelp_url)
    end
  end
end