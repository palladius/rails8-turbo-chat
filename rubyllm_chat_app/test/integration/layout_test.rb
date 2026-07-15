require "test_helper"

class LayoutTest < ActionDispatch::IntegrationTest
  test "footer contains File a bug link" do
    get root_url
    assert_response :success
    assert_select "footer a", text: "File a bug"
    assert_select "footer a[href=?]", "https://github.com/palladius/rails8-turbo-chat/issues/new"
  end
end
