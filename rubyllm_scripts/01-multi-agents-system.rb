
# copied from https://rubyllm.com/agentic-workflows/#multi-agent-systems

# gem 'ruby_llm', '~> 1.6', '>= 1.6.3'

require './lib/gemini_init'


class ResearchAgent < RubyLLM::Tool
  description "Researches topics"
  param :topic, desc: "Topic to research"

  def execute(topic:)
    RubyLLM.chat(model: 'gemini-2.5-pro')
           .ask("Research #{topic}. List key facts.")
           .content
  end
end

class WriterAgent < RubyLLM::Tool
  description "Writes content based on research"
  param :research, desc: "Research findings"

  def execute(research:)
#    RubyLLM.chat(model: 'claude-3-5-sonnet')
    RubyLLM.chat()
           .ask("Write an article:\n#{research}")
           .content
  end
end

# Coordinator uses both tools
coordinator = RubyLLM.chat.with_tools(ResearchAgent, WriterAgent)
#article = coordinator.ask("Create an article about Ruby 3.3 features")
#article = coordinator.ask("Create an article about latest MTG Standard: which decks are most popular after July 2025 rotation and so on.")
article = coordinator.ask("Create an article about latest MTG Standard: which decks are most popular: title, important cards present in it, and combo/how it wins.")
#print(article.content)
#puts(article.text)
# Create an "article.md"
File.write("mtg-article.md", article.content)
puts("[disk emoji] Written to: mtg-article.md")
