require 'test_helper'

# Assert_match checks that first arguements is within the second, also accepts regex

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:ExampleUser)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    
    assert_equal "#{user.name}'s Account Activation Information", mail.subject
    assert_equal [user.email], mail.to # Must include [] brackets to match mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded # Check for the user's name in the email body
    assert_match user.activation_token, mail.body.encoded # Make sure email has activation_token
    assert_match CGI::escape(user.email), mail.body.encoded # Check that "escaped" email form shows up
  end

  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
