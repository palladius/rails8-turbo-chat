require "application_system_test_case"

class ChatImageGenerationTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  include ActiveJob::TestHelper

  setup do
    @user = User.create!(email: "tester@example.com", password: "password", password_confirmation: "password")
    @chat = @user.chats.create!(title: "Test Chat")
    @chat.messages.create!(role: "user", content: "Hello!")
    @chat.messages.create!(role: "model", content: "Hi there!")
    @chat.messages.create!(role: "user", content: "Tell me a story about a ruby gem.")
    @chat.messages.create!(role: "assistant", content: "Once upon a time, there was a shiny red ruby gem.")
  end

  test "generating and regenerating an image for a chat" do
    # Sign in using Warden test helper
    login_as(@user, scope: :user)

    # Go to the chat
    visit chat_path(@chat)
    
    unless page.has_css?("input[type='submit'][value='🪄 Generate Image']")
      puts "HTML OF THE PAGE:"
      puts page.html
    end

    # 1. Initially, there's no image.
    
    # We mock or run the job inline to see the result.
    # Mocking RubyLLM to avoid hitting the actual API
    fake_chat = Object.new
    fake_chat.define_singleton_method(:ask) do |prompt|
      Struct.new(:content).new("Fake image prompt")
    end
    
    RubyLLM.define_singleton_method(:chat) do
      fake_chat
    end

    RubyLLM.define_singleton_method(:paint) do |prompt, model:|
      Object.new.tap do |fake_image|
        fake_image.define_singleton_method(:save) do |path|
          File.write(path, "fake image data")
        end
      end
    end
    
    perform_enqueued_jobs do
      click_on "🪄 Generate Image"
      assert_text "🖼️ Image generation started"
    end

    # The image should be generated and attached now.
    @chat.reload
    assert @chat.generated_image.attached?, "Image was not generated on first click"

    # Reload page to see the image and "Regenerate" button
    visit chat_path(@chat)
    
    # Let's save the blob id of the first image to verify it actually changes
    first_blob_id = @chat.generated_image.blob_id

    # 2. Now click "Regenerate"
    RubyLLM.define_singleton_method(:paint) do |prompt, model:|
      Object.new.tap do |fake_image|
        fake_image.define_singleton_method(:save) do |path|
          File.write(path, "fake image data 2")
        end
      end
    end
    
    perform_enqueued_jobs do
      click_on "🔄 Regenerate"
      assert_text "🖼️ Image generation started"
    end

    @chat.reload
    # This assertion fails because the job currently skips generation if an image is attached.
    assert_not_equal first_blob_id, @chat.generated_image.blob_id, "Image was not regenerated. The blob_id is the same!"
  end
end
