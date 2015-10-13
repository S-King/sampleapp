require 'test_helper'

# Use colons to access CONTROLLER ACTIONS, ex :edit, :index

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user =       users(:ExampleUser) #Finds from users.yml
    @other_user = users(:Second)
  end
  
  test "Should redirect to index request when not logged in" do
    get :index # HTTP GET request for :index controller action
    assert_redirected_to login_url # Check that the attempt is redirected to login, not authorized
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "Should redirect edit to login path and flash when not logged in" do
    get :edit, id: @user #id: @user is a rails convention for controller redirects 
    #that automatically uses @user.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "Redirect update and flash if not logged in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    #Here we need an additional 'user' hash for PATCH routes to work correctly
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "Should send to root and flash when incorrect user requests edit" do
    log_in_as(@other_user) #Log in as :Second
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "Should send to root and flash when incorrect user requests update" do
    log_in_as(@other_user)
    # Issues patch request to :update action
    patch :update, id: @user, user: { name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  # Action-level tests of access control should be put in our users controller test
  test "Destroy requests should be redirected if the user isn't logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user # Issue delete request to destroy method with @user's id
    end
   assert_redirected_to login_url
  end
  
  test "Redirect destroy request if not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id:@user
    end
   assert_redirected_to root_url
  end
end
