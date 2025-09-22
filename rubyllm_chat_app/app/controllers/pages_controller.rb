class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:about]

  def about
  end

    # NOT NEEDED!
  # def config
  # end

end
