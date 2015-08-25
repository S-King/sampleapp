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
end
