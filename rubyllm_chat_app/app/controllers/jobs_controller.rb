class JobsController < ApplicationController
  # Skip CSRF protection for this API endpoint
  skip_before_action :verify_authenticity_token
  # Skip Devise authentication for this API endpoint
  skip_before_action :authenticate_user!

  # Protect this endpoint with a shared secret token
  before_action :authenticate_cloud_scheduler

  def autotitle_chats
    # Enqueue the job to run in the background
    AutotitleChatsJob.perform_later
    head :ok
  end

  private

  def authenticate_cloud_scheduler
    # Use a shared secret token for authentication
    # The token should be stored in a secure environment variable (e.g., CLOUD_SCHEDULER_SECRET)
    # and sent by Cloud Scheduler in a header (e.g., X-Cloud-Scheduler-Secret)
    unless request.headers['X-Cloud-Scheduler-Secret'] == ENV['CLOUD_SCHEDULER_SECRET']
      Rails.logger.warn "Unauthorized access attempt to /jobs/autotitle_chats"
      head :unauthorized
    end
  end
end
