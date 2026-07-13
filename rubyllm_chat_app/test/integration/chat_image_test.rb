require "test_helper"

class ChatImageTest < ActionDispatch::IntegrationTest
  test "chat partial includes onerror retry for race condition" do
    user = User.create!(email: "test_#{Time.now.to_i}@example.com", password: "password")
    chat = Chat.create!(title: "Test Chat", model_id: "gemini-1.5-flash", user_id: user.id, public: true)
    
    image_path = Rails.root.join("test", "fixtures", "files", "dummy.png")
    unless File.exist?(image_path)
      FileUtils.mkdir_p(File.dirname(image_path))
      File.write(image_path, "dummy image content")
    end
    
    chat.generated_image.attach(io: File.open(image_path), filename: "dummy.png", content_type: "image/png")
    
    post user_session_path, params: { user: { email: user.email, password: "password" } }
    
    get chat_url(chat)
    assert_response :success
    
    # Assert that the image tag contains the onerror handler for retries
    assert_select "img[onerror*='setTimeout']"
  end
end
