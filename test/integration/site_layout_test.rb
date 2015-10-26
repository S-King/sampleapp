require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "layout links" do # testing the links in the layout files
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 # the question mark here allows rails to insert the appropriate path
    assert_select "a[href=?]", help_path          # "/help" (escaping any special charaters if it needs to)
    assert_select "a[href=?]", about_path         # It is good code to only test HTML elements (that are unlikely to change often) with assert_select
    assert_select "a[href=?]", contact_path
    # CH. 9 Ex. 2
    user = users(:ExampleUser) # Set up admin user
    assert_select "a[href=?]", login_path # Check for login link
    log_in_as(user) # Log in as admin user
    get root_path # Go to homepage and check links
    assert_select "a[href=?]", logout_path # Check for logout link
    assert_select "a[href=?]", users_path # Check for index link
    assert_select "a[href=?]", user_path(user) # Profile link
    assert_select "a[href=?]", edit_user_path(user) # Edit link
  end
end
