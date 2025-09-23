# all business logic goes here
APP_NAME = 'Rails8 Gemini2.0 rubyllm Responsive App v2'
APP_VERSION = File.read('VERSION').chomp
SHORT_APP_NAME = 'rails8-turbo-chat'
GITHUB_REPO = 'https://github.com/palladius/rails8-turbo-chat'

#RICC_CONFIG = {}
#  auto_rename
CONFIG_AUTORENAME_TITLES = ENV.fetch('CONFIG_AUTORENAME_TITLES', 'false').to_s.downcase == 'true'
DEBUG = ENV.fetch('DEBUG', 'false').to_s.downcase == 'true'
RAILS_MASTER_KEY =  ENV.fetch('RAILS_MASTER_KEY', nil) # .to_s.downcase == 'true'
GIT_LAST_COMMENT = ENV.fetch('GIT_LAST_COMMENT', '[Last comment not available - likely this is running locally and not in the Cloud]')
GIT_COMMIT_HASH = `git rev-parse --short HEAD`.strip rescue 'git rev-parse error'


CLOUD_RUN_ENDPOINT_FROM_ENV = ENV.fetch('CLOUD_RUN_ENDPOINT', nil)

CLOUD_RUN_ENDPOINTS = {
  # Todo chwnge with rails8-turbo-chat something..
  dev: "https://#{SHORT_APP_NAME}-dev-272932496670.europe-west10.run.app/", # done
  prod: "https://#{SHORT_APP_NAME}-prod-272932496670.europe-west10.run.app/", # not done yet
}

#def print_env_variable(key:, value:, emoji: '🌱', limit: nil)
def print_env_variable(key, value=:auto_detect, limit: nil, emoji: '🌱')
  max_size = 30
  spacing = " " * (max_size - key.size) rescue ' '
  if value == :auto_detect
    value = ENV.fetch(key, "❌ ENV[#{key}] missing")
  end
  printable_value = (limit ?  (value[0..limit] + ".. [L=#{value.to_s.length}]") : value) rescue "print_env_variableErr: #{$!}"
  puts("#{emoji} #{Rainbow(key).white}:#{spacing}#{Rainbow(printable_value).yellow }")
end

puts("👋 Welcome to #{Rainbow(APP_NAME).cyan} v#{Rainbow(APP_VERSION).blue}")
puts("")
print_env_variable('CONFIG_AUTORENAME_TITLES', CONFIG_AUTORENAME_TITLES)
print_env_variable('DEBUG', DEBUG)
print_env_variable('RAILS_MASTER_KEY', RAILS_MASTER_KEY, limit: 5)
print_env_variable('GIT_LAST_COMMENT', GIT_LAST_COMMENT)
print_env_variable('GEMINI_API_KEY', limit: 4)
print_env_variable('GCS_CREDENTIALS_JSON', limit: 10)

puts("💾 [cloudbuild relevant configs]")
print_env_variable('PROJECT_ID')
print_env_variable('OBJC_DISABLE_INITIALIZE_FORK_SAFETY')
print_env_variable('RAILS_ENV')
print_env_variable('DATABASE_URL', emoji: '🔋')
print_env_variable('APP_NAME')
print_env_variable('GCLOUD_REGION')
print_env_variable('GIT_LAST_COMMENT')
print_env_variable('PORT')
#print_env_variable('CLOUD_RUN_ENDPOINTS', CLOUD_RUN_ENDPOINTS )
print_env_variable('CLOUD_RUN_ENDPOINTS[:dev]', CLOUD_RUN_ENDPOINTS[:dev] )
print_env_variable('CLOUD_RUN_ENDPOINTS[:prod]', CLOUD_RUN_ENDPOINTS[:prod] )


# Copiato da gemini-chat
RailsEnvCircle = Rails.env == "development" ? '🟡' : '🟢'

AppUrlDev  = "https://#{SHORT_APP_NAME}-dev-x42ijqglgq-ew.a.run.app/"
AppUrlProd = "https://#{SHORT_APP_NAME}-prod-x42ijqglgq-ew.a.run.app/"


#####################
# Accepted hosts
#####################
# https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
# Blocked hosts: rails8-gemini20-chat-manhouse-manhouse-272932496670.europe-west10.run.app, rails8-gemini20-chat-manhouse-manhouse-272932496670.europe-west10.run.app
# tutto dal proj number

module RubyllmChatApp
  class Application < Rails::Application

    #  Rails.application.config.hosts ...
    config.hosts << CLOUD_RUN_ENDPOINTS[:dev]
    config.hosts << CLOUD_RUN_ENDPOINTS[:prod]
    config.hosts << CLOUD_RUN_ENDPOINT_FROM_ENV unless CLOUD_RUN_ENDPOINT_FROM_ENV.nil?


  end
end
