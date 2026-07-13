require "test_helper"

class ChatCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get root_url
    assert_response :success
  end
end
