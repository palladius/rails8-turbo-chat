require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    sign_in users(:one)
    get about_url
    assert_response :success
  end

  test "should have a file a bug link in the footer" do
    sign_in users(:one)
    get about_url
    assert_select "a[href=?]", "https://github.com/palladius/rails8-turbo-chat/issues/new", text: /File a bug/
  end
end
