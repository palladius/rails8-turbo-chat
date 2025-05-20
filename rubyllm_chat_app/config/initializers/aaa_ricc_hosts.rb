# Note: This file need to come alphabetically BEFORE "fast_mcp" or it fails to load.

#   # MCP server responds otherwise with
  #   # {"jsonrpc":"2.0","error":{"code":-32600,"message":"Forbidden: Remote IP not allowed"},"id":null}
Rails.application.config.hosts <<  '104.135.186.22'  # Riccardo's work server IPv4
Rails.application.config.hosts << '[2001:4860:7:162f::fa]' # Riccardo's work server IPv6



#IPv6: ? 2001:4860:7:152f::fe
#IPv4: ? 104.135.186.22

#  Allowed client hosts for MCP.
RICC_ALLOWED_HOSTS = [
    '104.135.186.22' , # Riccardo's work server IPv4
    '[2001:4860:7:162f::fa]', # Riccardo's work server IPv6
    'localhost',
    '[2001:4860:7:152f::fe]', # Riccardo's work server IPv6 at 15:05
    # https://guides.rubyonrails.org/configuring.html
    IPAddr.new("::/0"),             # All IPv6 addresses.
    /.*\.google\.com/, # google.com and all subdomains

]
