require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    sign_in users(:one)
    get about_url
    assert_response :success
  end
end
