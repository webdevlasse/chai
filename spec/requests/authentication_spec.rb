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

describe "Authentification cycle working correctly: " do
  before (:all) do
    User.destroy_all
    @user1 = FactoryGirl.create :user1
    @user2 = FactoryGirl.create :user2
  end

  it "Shows Sign Up link and click redirects to Sign Up page" do
    visit root_path
    expect(page).to have_link("Sign up!")
    click_link "Sign up!"
    current_path.should eq(new_user_registration_path)
  end

  it "Lets User Sign Up from Home Page" do
    User.destroy_all
    visit root_path
    expect(page).to have_link("Sign up!")
    click_link "Sign up!"
    current_path.should eq(new_user_registration_path)
    within "#new_user" do
      fill_in "Email", :with => @user1.email
      fill_in "user_password", :with => "111111"
      fill_in "user_password_confirmation", :with => "111111"
      click_button "Sign up"
    end
    current_path.should eq(root_path)
  end

  it "Shows Sign In link and click redirects to Sign In page" do
    visit root_path
    expect(page).to have_link("Sign in")
    click_link "Sign in"
    current_path.should eq(new_user_session_path)
  end

  it "Lets User Sign In from Home Page" do
    visit root_path
    expect(page).to have_link("Sign in")
    click_link "Sign in"
    current_path.should eq(new_user_session_path)
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => @user2.password
      click_button "Sign in"
    end
    current_path.should eq(root_path)
  end

  it "Shows Sign Out link when logged in" do
    visit root_path
    click_link "Sign in"
    current_path.should eq(new_user_session_path)
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => @user2.password
      click_button "Sign in"
    end
    expect(page).to have_link("Sign out")
    expect(page).to have_link("#{@user2.email}")
  end

  it "Lets User Sign Out from Home Page" do
    visit root_path
    click_link "Sign in"
    current_path.should eq(new_user_session_path)
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => @user2.password
      click_button "Sign in"
    end
    expect(page).to have_link("Sign out")
    expect(page).to have_link("#{@user2.email}")
    click_link "Sign out"
    expect(page).to have_link("Sign in")
  end

  it "Shows Forgot your password? when on Sign in & Sign Up" do
    visit new_user_session_path
    expect(page).to have_link("Forgot your password?")
    new_user_registration_path
    expect(page).to have_link("Forgot your password?")
  end

  it "Lets User request a new password" do
    visit new_user_session_path
    click_link "Forgot your password?"
    current_path.should eq(new_user_password_path)
    within "#new_user" do
      fill_in "Email", :with => @user2.email
    end
    click_button "Send me reset password instructions"
    current_path.should eq(new_user_session_path)
  end

  it "Shows Edit User when Signed in link is clicked" do
    visit root_path
    click_link "Sign in"
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => @user2.password
      click_button "Sign in"
    end
    visit root_path
    click_link "#{@user2.email}"
    current_path.should == edit_user_registration_path
  end

  it "Lets User edit/change the password" do
    visit root_path
    click_link "Sign in"
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => @user2.password
      click_button "Sign in"
    end
    visit root_path
    click_link "#{@user2.email}"
    current_path.should == edit_user_registration_path
    within "#edit_user" do
      fill_in "Email", :with => @user2.email
      fill_in 'user_password', :with => "111111"
      fill_in 'user_password_confirmation', :with => "111111"
      fill_in "Current password", :with => @user2.password
      click_button "Update"
    end
    current_path.should eq(root_path)
    click_link "Sign out"
    visit root_path
    click_link "Sign in"
    current_path.should eq(new_user_session_path)
    within "#new_user" do
      fill_in "Email", :with => @user2.email
      fill_in "user_password", :with => "111111"
      click_button "Sign in"
    end
    current_path.should eq(root_path)
  end
end
