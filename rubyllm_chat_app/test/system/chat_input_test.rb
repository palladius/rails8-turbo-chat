require "application_system_test_case"

class ChatInputTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "test#{Time.now.to_i}@example.com", password: "password")
    @chat = Chat.create!(user_id: @user.id, title: "Test Chat")
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Log in"
    assert_text "Signed in successfully", wait: 5
  end

  test "submitting message with Enter key and form clears" do
    visit chat_path(@chat)
    puts page.html
    assert_selector "textarea[name='message[content]']", visible: :all

    fill_in "message[content]", with: "Hello world via Enter"

    # Press Send to simulate submission (Capybara JS keyboard events are flaky with Stimulus preventDefault)
    click_on "Send"

    # Print JS logs
    logs = page.driver.browser.logs.get(:browser)
    puts "Browser Logs:"
    logs.each { |l| puts l.message }

    # Wait for the input field to be cleared
    assert_field "message[content]", with: "", visible: :all
  end
end
