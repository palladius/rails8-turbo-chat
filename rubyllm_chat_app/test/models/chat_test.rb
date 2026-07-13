require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "with_attached_generated_image does not return duplicates if a chat has multiple attachments" do
    user = User.create!(email: "test@example.com", password: "password123")
    chat = Chat.create!(title: "Test Chat", model_id: "gemini-1.5-pro", public: true, user_id: user.id)
    
    blob1 = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("test1"), filename: "test1.png", content_type: "image/png")
    blob2 = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("test2"), filename: "test2.png", content_type: "image/png")
    
    # Simulate the bug where a chat somehow ends up with multiple attachments for generated_image
    ActiveStorage::Attachment.create!(name: "generated_image", record_type: "Chat", record_id: chat.id, blob_id: blob1.id)
    ActiveStorage::Attachment.create!(name: "generated_image", record_type: "Chat", record_id: chat.id, blob_id: blob2.id)

    # The query should not return duplicates
    count = Chat.with_attached_generated_image.where(id: chat.id).to_a.size
    assert_equal 1, count, "Chat should only be returned once even with multiple attachments"
  end
end
