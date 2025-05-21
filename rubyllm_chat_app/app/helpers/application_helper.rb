module ApplicationHelper
  def app_metadata
    {
      APP_NAME: APP_NAME, # 'RubyLLM Chat App',
      APP_EMOJI: APP_EMOJI,
      SHORT_APP_NAME: SHORT_APP_NAME,
      DEBUG: DEBUG,
      GIT_LAST_COMMENT: GIT_LAST_COMMENT,
      GIT_COMMIT_HASH: GIT_COMMIT_HASH,
      GITHUB_REPO: GITHUB_REPO,
      #GIT_COMMIT_DATE: GIT_COMMIT_DATE,
      #version: defined?(APP_VERSION) ? APP_VERSION : 'N/A',
      version: APP_VERSION,
      source: 'app/helpers/application_helper.rb',
      #description: 'This is a Ruby on Rails application that uses the RubyLLM gem to provide a chat interface for interacting with large language models.',
      dev_url: CLOUD_RUN_ENDPOINTS[:dev],
      prod_url: CLOUD_RUN_ENDPOINTS[:prod],

      # Cloud Run ENV: https://cloud.google.com/run/docs/configuring/services/overview-environment-variables
      K_SERVICE: ENV['K_SERVICE'],
      K_REVISION: ENV['K_REVISION'],
      FUNCTION_TARGET: ENV['FUNCTION_TARGET'],

      # TODO(ricc): add more metadata
      dev_mcp_url: CLOUD_RUN_ENDPOINTS[:dev] + "mcp/sse", # has trailing / so this is correct
      prod_mcp_url: CLOUD_RUN_ENDPOINTS[:prod] + "/mcp/sse",

      occasional_message: ENV.fetch('OCCASIONAL_MESSAGE', '😕 Sorry, ENV[OCCASIONAL_MESSAGE] not set.'),

    }
  end
end
