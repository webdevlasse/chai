require 'spec_helper'
require 'simplecov'
SimpleCov.start 'rails'


##############################################################################
# add:
# save_and_open_page
# for debugger that opens page at step where insterted
# !caution when using with GUARD - could lead to major annoyance!

# add:
# describe "something", :js => true do
# for awesome JS / Selenium testing with Capybara
# !caution when using with GUARD - could lead to major annoyance by browser activity!
##############################################################################


describe "Shop page should show shop relevant information" do
  before(:each) do
    Shop.destroy_all
    @test_shop = FactoryGirl.create(:shop1)
  end
  context "Shop page is found" do
    it "displays correct Shops page" do
      visit shop_path(@test_shop)
      expect(page).to have_link("Look this shop up on Yelp")
    end

    xit "redirects user to yelp page of shop", :js => true do
      visit shop_path(@test_shop)
      click_link "Look this shop up on Yelp"
      current_path.should eq(@test_shop.yelp_url)
    end
  end
end