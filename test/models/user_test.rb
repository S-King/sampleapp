require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup # Special method that gets run before each test
    @user = User.new(name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar")
  end
  
  test "authenticated? should return false if :remember_digest is nil" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  
  test "User model should be valid" do
    assert @user.valid?
  end
  
  test "Users should have names" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "Users should have emails" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "Name should be <50 Char" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "Email should be <50 char" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "Users must submit valid email format" do
    valid_addresses = %w[user@example.com USER@foo.com A_US-user@foo.bar.org first.last@me.you.us me+you@baba.djk]
      valid_addresses.each do | valid_address |
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid" # The second arguement is a custom error message with the failing address
      end
  end
  
  test "System should reject invalid addresses" do
    invalid_addresses = %w[user@example,com doubledot@fukcomcast..net user_at_foo.org user.name@example. foot@bar foo@bar_bas.com foo@bar+baa.com]
      invalid_addresses.each do | invalid_address |
        @user.email = invalid_address
        assert_not @user.valid?, "#{invalid_address.inspect} is not a valid e-mail address"
      end
  end
  
  test "All emails should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "Passwords should be at least 6 char" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "Passwords shouldn't be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
end
