class ChatCardsController < ApplicationController
  def index
    if current_user
      if params[:show_all]
        @chats = current_user.chats.or(Chat.where(public: true)).order(updated_at: :desc)
      else
        @chats = current_user.chats.with_attached_generated_image.or(Chat.where(public: true).with_attached_generated_image).order(updated_at: :desc)
      end
    else
      # For logged out users, only show public chats, optionally filtered by image
      if params[:show_all]
        @chats = Chat.where(public: true).order(updated_at: :desc)
      else
        @chats = Chat.where(public: true).with_attached_generated_image.order(updated_at: :desc)
      end
    end
  end
end