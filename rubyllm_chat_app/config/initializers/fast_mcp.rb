# frozen_string_literal: true

########################################################################################################################
# Ricc: i did NOt take the versin from https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399
# I took the version created with the command: `bin/rails generate fast_mcp:install` as per documentation in https://github.com/yjacquin/fast-mcp
########################################################################################################################

# FastMcp - Model Context Protocol for Rails
# This initializer sets up the MCP middleware in your Rails application.
#
# In Rails applications, you can use:
# - ActionTool::Base as an alias for FastMcp::Tool
# - ActionResource::Base as an alias for FastMcp::Resource
#
# All your tools should inherit from ApplicationTool which already uses ActionTool::Base,
# and all your resources should inherit from ApplicationResource which uses ActionResource::Base.

# Mount the MCP middleware in your Rails application
# You can customize the options below to fit your needs.
require 'fast_mcp'


FastMcp.mount_in_rails(
  Rails.application,
  name: Rails.application.class.module_parent_name.underscore.dasherize,
  version: '1.0.3',
  path_prefix: '/mcp', # This is the default path prefix
  messages_route: 'messages', # This is the default route for the messages endpoint
  sse_route: 'sse', # This is the default route for the SSE endpoint
  # Add allowed origins below, it defaults to Rails.application.config.hosts
  allowed_origins: RICC_ALLOWED_HOSTS,
  # localhost_only: true, # Set to false to allow connections from other hosts
  localhost_only: false,
  # whitelist specific ips to if you want to run on localhost and allow connections from other IPs
  #allowed_ips: ['127.0.0.1', '::1'] + RICC_ALLOWED_HOSTS,
  allowed_ips: RICC_ALLOWED_HOSTS,
  # authenticate: true,       # Uncomment to enable authentication
  # auth_token: 'your-token', # Required if authenticate: true
) do |server|
  Rails.application.config.after_initialize do
    # FastMcp will automatically discover and register:
    # - All classes that inherit from ApplicationTool (which uses ActionTool::Base)
    # - All classes that inherit from ApplicationResource (which uses ActionResource::Base)
    server.register_tools(*ApplicationTool.descendants)
    server.register_resources(*ApplicationResource.descendants)
    # alternatively, you can register tools and resources manually:
    # server.register_tool(MyTool)
    # server.register_resource(MyResource)
    #server.register_tool(CreateUser)
    #server.register_tool(ListUser)
  end
end
