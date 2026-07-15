require "application_system_test_case"

class ChatsMobileTest < ApplicationSystemTestCase
  # Override screen size for this specific test
  setup do
    page.driver.browser.manage.window.resize_to(375, 812) # iPhone X dimensions
    sign_in users(:one)
    
    @chat = Chat.create!(user_id: users(:one).id, title: "Test Chat")
  end

  test "left pane is hidden on mobile and can be toggled" do
    visit chat_url(@chat)
    
    # Check that left pane is hidden (not visible)
    assert_selector "#chats-list", visible: :hidden

    # Check that the toggle button exists and is visible
    assert_selector "#toggle-chats-list", visible: true
    
    # Click toggle button
    click_button "Change Chat"
    
    # Left pane should now be visible
    assert_selector "#chats-list", visible: true
    
    # Optional: Chat content might be hidden or just pushed down,
    # but the main issue is that the left pane takes up too much space initially.
    # By default, we expect the right pane to be fully visible and taking 100% width.
    assert_selector ".chat-content", visible: :hidden
  end
end
