require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @chat = chats(:one)
    sign_in @user
  end

  test "should upvote chat" do
    assert_difference('@chat.reload.upvotes', 1) do
      patch upvote_chat_url(@chat)
    end
    assert_redirected_to chat_url(@chat)
  end
end
