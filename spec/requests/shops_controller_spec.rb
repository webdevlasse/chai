require 'spec_helper'


describe "Shops Controller" do
  describe "#show" do
    context "When not logged in" do
      it "Does not show the user the rate shop things" do
        shop = FactoryGirl.create(:shop)
        visit shop_path(shop)
        # page.should_not include_partial "visit/form"
        page.should_not have_button("Rate your visit")
      end
    end
  end
end