require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "language emoji" do
    chat = Chat.new(language: 'it')
    assert_equal '🇮🇹', chat.language_emoji

    chat.language = 'en'
    assert_equal '🇬🇧', chat.language_emoji

    chat.language = 'es'
    assert_equal '🇪🇸', chat.language_emoji

    chat.language = 'unknown'
    assert_equal '🏳️', chat.language_emoji
  end

  test "default language is en" do
    chat = Chat.new
    assert_equal 'en', chat.language
  end
end
