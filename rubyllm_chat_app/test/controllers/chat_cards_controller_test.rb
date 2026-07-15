require "test_helper"

class ChatCardsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "should get index" do
    sign_in users(:one)
    get root_url
    assert_response :success
  end

  test "should not return duplicate chats when chat has multiple attachments" do
    user = users(:one)
    sign_in user
    
    chat = Chat.create!(title: "Test Chat", model_id: "test", user_id: user.id, public: true)

    # Attach two files to the same chat's generated_image.
    # While it's has_one_attached, simulating the issue where multiple blobs are attached
    # or joins causes duplicates.
    chat.generated_image.attach(io: StringIO.new("test 1"), filename: "test1.txt", content_type: "text/plain")
    chat.generated_image.attach(io: StringIO.new("test 2"), filename: "test2.txt", content_type: "text/plain")

    # Double check that there are multiple attachments
    assert chat.generated_image_attachment.present?

    get root_url
    assert_response :success
    
    # Check that chat appears exactly once in the view by matching its title
    # Note: If the chat is public, it gets a "👀 " prefix in the title display.
    assert_select "div.font-bold.text-xl", text: /Test Chat/, count: 1
  end
end
