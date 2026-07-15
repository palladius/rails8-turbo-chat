require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @chat = Chat.create!(title: "Test Chat", user_id: @user.id)
    
    # attach a dummy image
    require "open-uri"
    @chat.generated_image.attach(io: StringIO.new("dummy image"), filename: "dummy.png", content_type: "image/png")
  end

  test "should regenerate image by purging existing one first" do
    assert @chat.generated_image.attached?

    post generate_image_chat_url(@chat)

    assert_redirected_to chat_url(@chat)
    
    # We should assert that the old image was purged.
    # Since it's purged and a job is scheduled, the attachment should not exist until the job completes.
    # Actually, purge is immediate, and job performs asynchronously.
    @chat.reload
    assert_not @chat.generated_image.attached?
  end
end
