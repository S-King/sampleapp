require 'test_helper'
=begin
  # At least one form element
  assert_select "form"

  # Form element includes four input fields
  assert_select "form input", 4

  # Page title is "Welcome"
  assert_select "title", "Welcome"

  # Page title is "Welcome" and there is only one title element
  assert_select "title", {:count=>1, :text=>"Welcome"},
      "Wrong title or more than one title element"

  # Page contains no forms
  assert_select "form", false, "This page must contain no forms"

  # Test the content and style
  assert_select "body div.header ul.menu"

  # Use substitution values
  assert_select "ol>li#?", /item-\d+/

  # All input fields in the form have a name
  assert_select "form input" do
    assert_select "[name=?]", /.+/  # Not empty
  end
=end
class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:ExampleUser)
    @non_admin = users(:Second)
  end
  
  test "Visit Index as admin with pagination and delete links" do
    log_in_as(@admin) # Sign in as admin 
    get users_path # Visit index/allusers
    assert_template 'users/index' #Check for correct template
    assert_select 'div.pagination' #Default div for pages, check it exists
     first_page_of_users = User.paginate(page: 1) #Get a collection of first 30 users
      first_page_of_users.each do |user| # For each of the 30 users in first batch 
        assert_select 'a[href=?]', user_path(user), text: user.name #check links lead to user's
        #profile and the text is their name
        unless user == @admin # Run this block except for when users aren't admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete' #Check link and text
        end
      end
      
      assert_difference 'User.count', -1 do
        delete user_path(@non_admin)
      end
  end
  
  test "Shouldn't be able to delete as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
end
