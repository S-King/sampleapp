require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup # the setup method is automatically called at the beginning of every test
    @user = users(:ExampleUser) #users corresponds to users.yml filename
  end
  
  test "login with valid information followed by logout" do
    get login_path #Visit the login path
    #Post into the form with the email fixture's email and a password that will be digested
    #and match the password digest saved in the ExampleUser fixture
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in? #Check that session is created, using is_logged_in? defined in test_helper
    assert_redirected_to @user #Check that were going to the right user
    follow_redirect! #Visit the page redirected to
    assert_template 'users/show' #Made sure the template to display a user shows up
    assert_select "a[href=?]", login_path, count: 0 #Make sure login button disappears
    assert_select "a[href=?]", logout_path #Make sure a logout button shows up once
    assert_select "a[href=?]", user_path(@user) #See that a page to the users profile is there
    ### Now lets make sure we can logout correctly ###
    delete logout_path #Issue HTTP data request to the logout_path
    assert_not is_logged_in? #Check that session is deleted, using is_logged_in? defined in test_helper
    assert_redirected_to root_url # Check redirect specified in the destroy method of sessions controller
    # V Simulate a user clicking logout in a second window
    delete logout_path  
    
    follow_redirect! #Visit the redirected page
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path # Login button comes back
    assert_select "a[href=?]", logout_path, count: 0 # Logout button is gone
    assert_select "a[href=?]", user_path(@user), count: 0
    
  end
    
  
  
  test "login with invalid information" do
    get login_path # Visit login path
    #Verify new session form renders
    assert_template 'sessions/new' # Uses 'controller/action' unlike routes.rb => 'controller#action'
    #Post to sessions path with invalid params
    post login_path, session: { email: "", password: "" }
    #New session form gets re-rendered and flash appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    #Get another page, make sure flash is not present
    get root_path
    assert flash.empty?
  end
    
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal assigns(:user).remember_token, cookies['remember_token']
    #Check that once logged in the correct remember tokens are associated
    #<expected>, <actual> 
  end
  
  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
  
  def teardown # The teardown method is automatically called at the end of every test
  # so we could set any instance variables back to nil here is we needed to
  end
    
end
