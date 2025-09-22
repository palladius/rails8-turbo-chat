# typed: false
class ToolCall < ApplicationRecord
  # RubyLLM Integration
  acts_as_tool_call # Assumes Message model name

  # Standard Rails Model Logic
  belongs_to :message # The assistant message that initiated the call
  # Optional: Add association for the 'tool' role message containing the result
  # has_one :result_message, class_name: 'Message', foreign_key: 'tool_call_id', primary_key: 'id'

  # Validations
  validates :tool_call_id, presence: true, uniqueness: true
  validates :name, presence: true
  # arguments are jsonb, Rails handles validation implicitly to some extent
end
