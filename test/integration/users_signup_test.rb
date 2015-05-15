require 'test_helper'
require "capybara/rails"

class UsersSignupTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
  end
  
  test "error messages with invalid sign up" do
    visit signup_path
    fill_in "user[name]", with: "kristina"
    fill_in "user[email]", with: "sample@sample.com"
    click_button "Create my account"
    
    assert page.has_content?("Password can't be blank")
  end
  
  test "flash message with valid sign up" do
    visit signup_path
    fill_in "user[name]", with: "kristina"
    fill_in "user[email]", with: "sample@sample.com"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Create my account"
    
    assert page.has_content?("Welcome to the sample app!")
  end
end
