module ApplicationHelper
  def app_metadata
    {
      app_name: 'RubyLLM Chat App',
      #version: defined?(APP_VERSION) ? APP_VERSION : 'N/A',
      version: APP_VERSION,
      source: 'app/helpers/application_helper.rb',
      #description: 'This is a Ruby on Rails application that uses the RubyLLM gem to provide a chat interface for interacting with large language models.',
      dev_url: CLOUD_RUN_ENDPOINTS[:dev],
      prod_url: CLOUD_RUN_ENDPOINTS[:prod],
      # TODO(ricc): add more metadata
      dev_mcp_url: CLOUD_RUN_ENDPOINTS[:dev] + "mcp/sse", # has trailing / so this is correct
      prod_mcp_url: CLOUD_RUN_ENDPOINTS[:prod] + "/mcp/sse",

    }
  end
end
