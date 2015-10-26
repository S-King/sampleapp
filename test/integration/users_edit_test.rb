require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:ExampleUser)
  end
  
  
  #Visit edit page, make sure correct page, submit bad form, check for edit page
  test "Unsuccessful Edit" do
    log_in_as(@user) #Log in as the :ExampleUser from users.yml
    get edit_user_path(@user) #Get the edit page
    assert_template 'users/edit' #Looks in the views to see if /users/edit is returned
    patch user_path(@user), user: {name: "", email: "asd@no.no!", password: "NO", password_confirmation: "!" }
    #Submit the bad user, then check for the views/users/edit page to be redisplayed
    assert_template 'users/edit'
  end
  
  test "Sucessfull Edit and Friendly Forwarding only on first click" do
    get edit_user_path(@user)
    assert !session[:forwarding_url].nil? #Check that we have saved the forwarding url since it was a GET request
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
      name = "Example"
      email = "ex@ex.com" #Downcased email since our validations will downcase it
    patch user_path(@user), user: {name: "Example", email: "Ex@Ex.com", password: "", password_confirmation: "" }
    assert_not flash.empty? #Check that the flash box popped up, for success
    assert_redirected_to @user
    assert_nil session[:forwarding_url]
    @user.reload #Reload user to make sure the submitted data matches DB data
      assert_equal name, @user.name, "Name Error" # assert_equal(exp, act, msg = nil)
      assert_equal email, @user.email, "Email Error"
      
      #Check only forwarding on first click
  end

end
