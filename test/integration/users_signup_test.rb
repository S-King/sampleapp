require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest # Using plural naming convention, same as controllers
  # test "the truth" do
  #   assert true
  # end
  test 'Should reject invalid signup information' do 
    get signup_path # visit the signup path
      assert_no_difference 'User.count' do # make sure number of users is the same 
        post users_path, user: { name: "", # before and after submitting invalid data
            email: "user@invalid", password: "123",
            password_confirmation: "321" }
      end
    assert_template 'users/new'
  end
end
