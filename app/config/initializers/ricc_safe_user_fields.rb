
# inspired by https://github.com/heartcombo/devise/blob/354df3bc65fb211f0704208f52bf2213758585cf/lib/devise/models/authenticatable.rb#L59
# and https://stackoverflow.com/questions/53595363/how-to-avoid-accidentally-sending-sensitive-fields-from-my-model

Devise::Models::Authenticatable::BLACKLIST_FOR_SERIALIZATION << :gemini_api_key
