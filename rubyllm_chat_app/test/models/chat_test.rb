require "test_helper"

class ChatTest < ActiveSupport::TestCase
  setup do
    @user = users(:one) rescue User.first || User.create!(email: "test@example.com", password: "password")
  end

  test "can assign tags as string and parses them" do
    chat = Chat.new(title: "My Chat", model_id: "gemini-1.5-pro", user_id: @user.id)
    chat.tags = "ruby, rails, sobenme"
    chat.save!
    
    assert_equal "ruby, rails, sobenme", chat.tags
    assert_equal ["ruby", "rails", "sobenme"], chat.parsed_tags
    
    chat.tags = "#ruby #rails #sobenme"
    assert_equal ["ruby", "rails", "sobenme"], chat.parsed_tags
  end

  test "autotag_if_needed generates tags via Gemini if not present" do
    chat = Chat.create!(title: "My Chat", model_id: "gemini-1.5-pro", user_id: @user.id)
    chat.messages.create!(role: "user", content: "How to use Ruby on Rails?", model_id: "gemini-1.5-pro")
    chat.messages.create!(role: "model", content: "It is a framework.", model_id: "gemini-1.5-pro")
    
    mock_response = Struct.new(:content).new("#ruby #rails #webdev")
    mock_chat = Object.new
    mock_chat.define_singleton_method(:ask) { |prompt| mock_response }
    
    original_method = RubyLLM.method(:chat)
    RubyLLM.define_singleton_method(:chat) { mock_chat }
    begin
      chat.autotag_if_needed
    ensure
      RubyLLM.define_singleton_method(:chat, original_method)
    end
    
    assert_equal "#ruby #rails #webdev", chat.tags
    assert_equal ["ruby", "rails", "webdev"], chat.parsed_tags
  end
end
