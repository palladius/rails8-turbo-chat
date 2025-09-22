# typed: false
class ApplicationController < ActionController::Base
  # Ensure user is logged in for all actions (except Devise controllers)
  before_action :authenticate_user!
  # Add 'name' to permitted Devise parameters
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :configure_permitted

  protected

  # Allow 'name' parameter during sign_up and account_update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :gemini_api_key])
  end
end
