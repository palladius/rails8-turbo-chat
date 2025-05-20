# Note: This file need to come alphabetically BEFORE "fast_mcp" or it fails to load.

#   # MCP server responds otherwise with
  #   # {"jsonrpc":"2.0","error":{"code":-32600,"message":"Forbidden: Remote IP not allowed"},"id":null}
#IPv6: ? 2001:4860:7:152f::fe
#IPv4: ? 104.135.186.22

base_hosts =  [
  # localhosts
  'localhost',
  '127.0.0.1',
  '::1',
  '104.135.186.22' , # Riccardo's work server IPv4
  '2001:4860:7:162f::fa', # Riccardo's work server IPv6
  '2001:4860:7:152f::fe', # Riccardo's work server IPv6 at 15:05
  '2a00:79e0:2846:6:8068:8006:f319:4a7', # Riccardo's work server IPv6 as seen in logs.
  # https://guides.rubyonrails.org/configuring.html
  IPAddr.new("::/0"),             # All IPv6 addresses.
  #/.*\.google\.com/, # google.com and all subdomains
  'rails8-turbo-chat-dev-272932496670.europe-west10.run.app',
].uniq

COMMA_SEPARATED_ALLOWED_ORIGINS = ENV.fetch('COMMA_SEPARATED_ALLOWED_ORIGINS', nil)
if COMMA_SEPARATED_ALLOWED_ORIGINS
  ALLOWED_ORIGINS = COMMA_SEPARATED_ALLOWED_ORIGINS.split(',')
else
  ALLOWED_ORIGINS = []
end

#  Allowed client hosts for MCP.
RICC_ALLOWED_HOSTS = (base_hosts + ALLOWED_ORIGINS).uniq # .sort

# By checking the Cloud Run logs I'm connecting with
#  remoteIp: "2a00:79e0:2846:6:8068:8006:f319:4a7"


# 1. Add the allowed hosts to the Rails application config
RICC_ALLOWED_HOSTS.each do |host|
  Rails.application.config.hosts << host
end

# 2. remove auth from MCPs.. should be useless but im desperate.
Rails.application.config.host_authorization = {
  exclude: ->(request) { request.path.include?("mcp") }
}
