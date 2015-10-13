require 'test_helper'

# Helper for testing sessions, like persistent sessions set with the remember_me token
# Define user variable, call remember method on defined user, verify that current_user (from sessions_helper.rb) is equal to defined user
# this method works because the remember method doesn't set the session[:user_id]

class SessionsHelperTest < ActionView::TestCase
    
    def setup
        @user = users(:ExampleUser) #Setup @user to :ExampleUser from users.yml
        remember(@user) #Remember :Example User
    end
    
    test "current_user method should return correct user when session is nil" do 
        # Convention writes assert_equal <expected>, <actual>
        assert_equal @user, current_user 
        assert is_logged_in?
    end
    
    test "current_user should return nil when remember_digest is wrong" do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
    end
    
end
