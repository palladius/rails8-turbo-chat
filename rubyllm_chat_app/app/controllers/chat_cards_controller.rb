class ChatCardsController < ApplicationController
  def index
    if params[:show_all]
      @chats = current_user.chats.order(updated_at: :desc)
    else
      @chats = current_user.chats.with_attached_generated_image.order(updated_at: :desc)
    end
  end
end