require "test_helper"

class ChatCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get root_url
    assert_response :success
  end

  test "should not show duplicate chats when multiple images are attached" do
    sign_in users(:one)
    chat = Chat.create!(user_id: users(:one).id, public: true, title: "Test Chat", description: "Test Description")
    
    # Manually create two active storage attachments for the same record to simulate the issue
    blob1 = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("test"), filename: "test1.png", content_type: "image/png")
    blob2 = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("test"), filename: "test2.png", content_type: "image/png")
    
    ActiveStorage::Attachment.create!(name: "generated_image", record_type: "Chat", record_id: chat.id, blob_id: blob1.id)
    ActiveStorage::Attachment.create!(name: "generated_image", record_type: "Chat", record_id: chat.id, blob_id: blob2.id)
    
    get root_url
    assert_response :success
    
    assert_select "div.font-bold", text: "👀 Test Chat", count: 1
  end
end
