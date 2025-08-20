require 'async'

require './lib/gemini_init'

class ParallelAnalyzer
  def analyze(text)
    results = {}

    Async do |task|
      task.async do
        puts("🧵💪 [async][RubyLLM.chat] 1. Sentiment analysis...")
        results[:sentiment] = RubyLLM.chat
          .ask("Sentiment of: #{text}. One word: positive/negative/neutral")
          .content
        puts("🧵💪 [async][RubyLLM.chat] 1. .. Done")
      end

      task.async do
        puts("🧵💪 [async][RubyLLM.chat] 2. Summarizing...")
        results[:summary] = RubyLLM.chat
          .ask("Summarize in one sentence: #{text}")
          .content
        puts("🧵💪 [async][RubyLLM.chat] 2. .. Done")
      end

      task.async do
        puts("🧵💪 [async][RubyLLM.chat] 3. Extracting keywords...")
        results[:keywords] = RubyLLM.chat
          .ask("Extract 5 keywords: #{text}. Just provide the 5 comma-separated keywords, no additional text!")
          .content
        puts("🧵💪 [async][RubyLLM.chat] 3. .. Done")
      end
    end

    results
  end
end

# Usage
analyzer = ParallelAnalyzer.new
my_text = File.read("mtg-article.md")
insights = analyzer.analyze(my_text)
# All three analyses run concurrently
puts(insights)
