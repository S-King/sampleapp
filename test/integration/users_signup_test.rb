require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest # Using plural naming convention, same as controllers
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test 'Should reject invalid signup information' do 
    get signup_path # visit the signup path
      assert_no_difference 'User.count' do # make sure number of users is the same 
        post users_path, user: { name: "", # before and after submitting invalid data
            email: "user@invalid", password: "123",
            password_confirmation: "321" }
      end
      #Assert_template makes sure that the correct template is rendered
      
    assert_template 'users/new' #Asserts template 'users/new' was rendered
                                #can also use: assert_template layout: 'admin' for layout or nil/false 
    assert_not flash.nil? #Could also be written as assert_not_nil flash
        #Above we test flash error messages from application.html.erb view
    
      #Selects objects and makes equality tests: assert_select ‘td.highlight’, { :count => 2 }
      #finds 2 td tags with the highlight class.
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors' # After an invalid submission rails wraps fields with errors
                                          # in divs with CSS class .field_with_errors
  end

  test "Should accept valid information with account activation" do
    get signup_path #Visit the signup form page
    assert_difference 'User.count', 1 do #Assert that after the block user count is +1
      # post via redirect since we redirect once a user successfully logs in
      post users_path, user: {name: "Example User",
                                           email: "Exampleuser@example.com",
                                           password: "password",
                                           password_confirmation: "password"}
      end
    assert_equal 1, ActionMailer::Base.deliveries.size # Make sure email is sent
    # deliveries array is global and reset in setup
    user =  assigns(:user) #lets us access instance variables in corresponding action
    #Ex: Users controller's create action defines @user so we can access it in tests using assigns(:user)
    assert_not user.activated?
    log_in_as(user) # Try to log in before activation
    assert_not is_logged_in?
    
    # Index page
    #Valid user login
    log_in_as(users(:ExampleUser))
    get users_path, page: 2
    assert_no_match user.name, response.body
    #Profile page
    get user_path(user)
    assert_redirected_to root_url
    #Log out
    delete logout_path
    get edit_account_activation_path("invalid token") # Invalid token
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong email') # Right token, wrong email
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email) # Right token, right email
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.nil? #Check that the success flash pops up
  end
end
