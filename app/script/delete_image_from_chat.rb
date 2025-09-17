#!/usr/bin/env ruby

chat_id = ARGV.first
unless chat_id
  puts "Usage: rails runner script/delete_image_from_chat.rb <chat_id>"
  exit 1
end

chat = Chat.find_by(id: chat_id)
if chat
  if chat.generated_image.attached?
    puts "Found chat ##{chat.id} with an attached image. Deleting it..."
    chat.generated_image.purge
    puts "Image deleted from chat ##{chat.id}."
  else
    puts "Chat ##{chat.id} does not have an attached image."
  end
else
  puts "Could not find chat with ID #{chat_id}."
  exit 1
end
