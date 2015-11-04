require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:ExampleUser)
    @micropost = @user.microposts.build(content: "Lorem ipsum") 
    # Build returns and object in the memory but doesn't modify the DB
  end
  
  test "Should be valid" do
    assert @micropost.valid?
  end
  
  test "User ID should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "Content should be present" do
    @micropost.content = "        "
    assert_not @micropost.valid?
  end
  
  test "Text must be 140 char or less" do
    @micropost.content = "A" * 141
    assert_not @micropost.valid?
  end
  
  test "Order should show most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
