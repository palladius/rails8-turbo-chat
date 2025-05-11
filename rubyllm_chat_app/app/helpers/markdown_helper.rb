
#require 'kramdown' # Add this line to load the kramdown library

# typed: false
module MarkdownHelper



  def markdown_to_html(text)
    return "".html_safe if text.blank?

    # Convert Markdown to HTML using Kramdown
    # input: 'GFM' enables GitHub Flavored Markdown
    # hard_wrap: false is a common setting, adjust if you prefer hard line breaks to become <br>
    # The output of to_html is HTML, so it needs to be marked as html_safe.
    html = Kramdown::Document.new(text.to_s, input: 'GFM', hard_wrap: false).to_html
    html.html_safe
  end

end
