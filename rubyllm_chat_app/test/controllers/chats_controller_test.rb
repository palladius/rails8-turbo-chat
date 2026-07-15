require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    # Devise fixtures usually need a password, let's see if this works
    sign_in @user
  end

  test "should create chat and redirect with 303 see other" do
    post chats_url, params: { chat: { title: "Turbo Chat" } }, as: :turbo_stream
    assert_response :see_other
    assert_redirected_to chat_url(Chat.last)
  end
end
