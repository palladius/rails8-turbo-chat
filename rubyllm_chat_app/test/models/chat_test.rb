require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "language defaults to en" do
    chat = Chat.new(title: "Test Chat", user_id: 1, model_id: "gemini-1.5-flash")
    chat.valid?
    assert_equal "en", chat.language
  end

  test "flag emoji mapping" do
    chat = Chat.new(language: "en")
    assert_equal "🇬🇧", chat.flag_emoji

    chat.language = "it"
    assert_equal "🇮🇹", chat.flag_emoji

    chat.language = "fr"
    assert_equal "🇫🇷", chat.flag_emoji

    chat.language = nil
    assert_equal "🏳️", chat.flag_emoji
  end
end
