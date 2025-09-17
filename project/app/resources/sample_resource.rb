# frozen_string_literal: true

class SampleResource < ApplicationResource
  uri 'examples/users'
  resource_name 'Users'
  description 'A user resource for demonstration (which Riccardo made safe, no trace of API Keys now)'
  mime_type 'application/json'

  def content
    JSON.generate(User.all.as_json)
    # seems a bit too much with password and API keys :) Oh no, lok below. Fixed with 0.3.3!
  end
end


# sample resource:
# {"id"=>1,
#   "email"=>"palladiusbonton@gmail.com",
#   "created_at"=>"2025-05-13T07:55:53.555Z",
#   "updated_at"=>"2025-05-13T07:55:53.555Z",
#   "name"=>"Riccardo Carlesso",
#   "gemini_api_key"=>nil},

# fixed with this: Devise::Models::Authenticatable::BLACKLIST_FOR_SERIALIZATION << :gemini_api_key
