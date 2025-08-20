require './lib/gemini_init'

require 'async'

class CodeReviewSystem
  def review_code(code)
    Async do |task|
      # Run reviews in parallel
      reviews = {}
      puts("Starting code reviews...")

      task.async do
        puts("Starting code review #1...")
        reviews[:security] = RubyLLM.chat() # model: 'claude-3-5-sonnet')
          .ask("Security review:\n#{code}")
          .content
      end

      task.async do
        puts("Starting code review #2...")
        reviews[:performance] = RubyLLM.chat() # model: 'gpt-4o'
          .ask("Performance review:\n#{code}")
          .content
      end

      task.async do
        puts("Starting code review #3...")
        reviews[:style] = RubyLLM.chat() # model: 'gpt-4o-mini'
          .ask("Style review (Ruby conventions):\n#{code}")
          .content
      end

      task.wait # Wait for all reviews

      # Synthesize findings
      RubyLLM.chat.ask(
        "Summarize these code reviews:\n" +
        reviews.map { |type, review| "#{type}: #{review}" }.join("\n\n")
      ).content
    end
  end
end

x = CodeReviewSystem.new
x.review_code("def hello_world\n  puts 'Hello, world!'\nend")
