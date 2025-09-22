# frozen_string_literal: true

class RiccardoEasterEgg < ApplicationResource
  uri 'example/riccardo_easter_eggs'
  resource_name 'EasterEggs'
  description 'A sample resource to test Riccardo Easter Eggs'
  mime_type 'application/json'

  def content
    #return JSON.generate(User.all.as_json)
    return JSON.generate(
      {
        name: 'Riccardo Carlesso',
        favourite_language: 'Ruby',
        favourite_framework: 'Ruby on Rails',
        favourite_color: 'Yellow',
        favourite_food: 'Chicken Balti',
        favourite_quote: 'Code is like humor. When you have to explain it, its bad.',
        favourite_book: 'The hitchhiker\'s guide to the galaxy',
        favourite_emoji: '💛',
      }
    )
  end
end
