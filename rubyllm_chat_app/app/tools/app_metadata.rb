class AppMetadata < ApplicationTool
  include ApplicationHelper
  description 'Gives metadata about the app, including the name, version, and description.'

  def call
    # Defined in the ApplicationHelper
    a = app_metadata()
    a.to_json
  end
end
