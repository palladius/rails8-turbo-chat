require "test_helper"

class McpCommunicationTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Origin" => "http://localhost",
      "REMOTE_ADDR" => "127.0.0.1"
    }
  end

  test "MCP SSE endpoint is reachable" do
    get "/mcp/sse", headers: @headers
    assert_response :success
    assert_equal "text/event-stream", response.media_type
  end

  test "MCP message endpoint is reachable" do
    post "/mcp/messages", params: {
      jsonrpc: "2.0",
      id: 1,
      method: "tools/list"
    }.to_json, headers: @headers.merge("Content-Type" => "application/json")
    
    assert_response :success
  end
end
