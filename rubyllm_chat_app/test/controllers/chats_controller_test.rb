require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should create chat via turbo stream with see_other status" do
    assert_difference("Chat.count") do
      post chats_url, params: { chat: { title: "Test Chat" } }, as: :turbo_stream
    end

    assert_response :see_other
    assert_redirected_to chat_url(Chat.last)
  end
end
