class AutotitleChatsJob < ApplicationJob

  # We might want to use a different queue for long-running jobs
  # queue_as :low_priority

  # Cloud Scheduler needs to call this with CLOUD_SCHEDULER_SECRET
  def perform
    # Do something later
    Chat.autotitle_if_needed
  end
end
