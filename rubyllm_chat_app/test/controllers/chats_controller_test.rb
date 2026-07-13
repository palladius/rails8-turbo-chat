require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "test_chat_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    @chat = Chat.create!(user_id: @user.id, title: "Test", model_id: "gpt-4o-mini", public: true)
    post user_session_url, params: { user: { email: @user.email, password: "password" } }
  end

  test "generate_image should purge existing image and enqueue job" do
    require 'tempfile'
    tempfile = Tempfile.new(['dummy', '.png'])
    tempfile.write('dummy content')
    tempfile.rewind
    @chat.generated_image.attach(io: tempfile, filename: 'dummy.png', content_type: 'image/png')
    assert @chat.generated_image.attached?

    assert_enqueued_with(job: GenerateChatImageJob) do
      post generate_image_chat_url(@chat)
    end
    
    @chat.reload
    assert_not @chat.generated_image.attached?
    
    assert_redirected_to chat_url(@chat)
  end
end
