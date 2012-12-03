require 'spec_helper'

# describe "Static Pages should work!" do

#   describe "Home should bring you to root_path" do
#     it "reloads current page when already in Home" do
#       visit root_path
#       click_link "Chai_3"
#       current_path.should eq(root_path)
#     end

#     it "brings User from About to Home via click on Icon" do
#       visit about_path
#       page.should have_content("About Chai")
#     end

#     it "brings User from About to Home via Home link" do
#       visit about_path
#       click_link "Home"
#       current_path.should eq(root_path)
#     end

#     it "brings User from Contact to Home via click on Icon" do
#       visit contact_path
#       click_link "Chai_3"
#       current_path.should eq(root_path)
#     end

#     it "brings User from Contact to Home via Home link" do
#       visit contact_path
#       click_link "Home"
#       current_path.should eq(root_path)
#     end

#     it "brings User from FAQ to Home via click on Icon" do
#       visit faq_path
#       click_link "Chai_3"
#       current_path.should eq(root_path)
#     end

#     it "brings User from FAQ to Home via Home link" do
#       visit faq_path
#       click_link "Home"
#       current_path.should eq(root_path)
#     end
#   end

#   describe "About should bring you to about_path" do
#     it "brings User to About from Home" do
#       visit root_path
#       click_link "About"
#       current_path.should eq(about_path)
#     end

#     it "brings User to About from Contact" do
#       visit contact_path
#       click_link "About"
#       current_path.should eq(about_path)
#     end

#     it "brings User to About from FAQ" do
#       visit faq_path
#       click_link "About"
#       current_path.should eq(about_path)
#     end
#   end

#   describe "Contact should bring you to contact_path" do
#     it "brings User to Contact from Home" do
#       visit root_path
#       click_link "Contact"
#       current_path.should eq(contact_path)
#     end

#     it "brings User to Contact from About" do
#       visit about_path
#       click_link "Contact"
#       current_path.should eq(contact_path)
#     end

#     it "brings User to Contact from FAQ" do
#       visit faq_path
#       click_link "Contact"
#       current_path.should eq(contact_path)
#     end
#   end

#   describe "FAQ should bring you to faq_path" do
#     it "brings User to FAQ from Home" do
#       visit root_path
#       click_link "FAQ"
#       current_path.should eq(faq_path)
#     end

#     it "brings User to FAQ from About" do
#       visit about_path
#       click_link "FAQ"
#       current_path.should eq(faq_path)
#     end

#     it "brings User to FAQ from Contact" do
#       visit contact_path
#       click_link "FAQ"
#       current_path.should eq(faq_path)
#     end
#   end
# end