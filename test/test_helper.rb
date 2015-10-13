ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters" # add red, green to reports #
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  # Add more helper methods to be used by all tests here...
  
  def is_logged_in? #This is analagous to the logged_in?  method in the 
  #SessionHelper but we don't have access to it during tests
    !session[:user_id].nil? # Not session for :user_id is nil
  end
  
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
     #^ Works because hashes return nil to nonexitant keys and doesn't short circuit
     if integration_test?
       post login_path, session: { email: user.email,
                              password: password,
                              remember_me: remember_me }
      else
        session[:user_id] = user.id
     end
  end
    
private
   
   # Test if this is an integration test, returns true if so
   def integration_test?
     defined?(post_via_redirect)
   end
   
end



