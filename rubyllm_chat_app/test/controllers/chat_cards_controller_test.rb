require "test_helper"

class ChatCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chat_cards_index_url
    assert_response :success
  end
end
