require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "layout links" do # testing the links in the layout files
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 # the question mark here allows rails to insert the appropriate path
    assert_select "a[href=?]", help_path          # "/help" (escaping any special charaters if it needs to)
    assert_select "a[href=?]", about_path         # It is good code to only test HTML elements (that are unlikely to change often) with assert_select
    assert_select "a[href=?]", contact_path
  end
end
