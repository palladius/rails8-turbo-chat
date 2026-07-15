require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    @chat = chats(:one) rescue Chat.create!(title: "Test Chat", model_id: "gpt-4", user_id: @user.id)
    
    # attach an image first
    @chat.generated_image.attach(
      io: StringIO.new("fake image data"),
      filename: "test.png",
      content_type: "image/png"
    )
  end

  test "should regenerate image by purging existing and enqueueing job" do
    sign_in @user
    
    assert @chat.generated_image.attached?
    
    assert_enqueued_with(job: GenerateChatImageJob) do
      post generate_image_chat_url(@chat)
    end
    
    @chat.reload
    assert_not @chat.generated_image.attached?
    assert_redirected_to chat_url(@chat)
    assert_equal "🖼️ Image generation started. It will appear shortly.", flash[:notice]
  end
end
