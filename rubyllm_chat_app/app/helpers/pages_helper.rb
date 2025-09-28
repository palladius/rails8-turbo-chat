module PagesHelper
  def display_env_variable(name, value)
    content_tag(:div, class: "flex items-center") do
      content_tag(:div, "#{name}:", class: "text-sm font-medium text-gray-400 mr-2") +
        if value.present?
          content_tag(:span, value.to_s, class: "font-semibold text-teal-300")
        else
          content_tag(:span, "Not set", class: "text-gray-500 italic")
        end
    end
  end

  def display_secret_env_variable(name, value, json:)
    content_tag(:div, class: "flex items-center") do
      concat(content_tag(:div, "🔑 #{name}:", class: "text-sm font-medium text-gray-400 mr-2"))
      if value.present?
        if json
          begin
            JSON.parse(value)
            concat(content_tag(:tt, "(valid JSON) #{value.first(10)}...", class: "font-bold bg-gray-700 px-3 py-1 rounded-md text-sky-300 shadow"))
          rescue JSON::ParserError
            concat(content_tag(:tt, "(invalid JSON) #{value.first(10)}...", class: "font-bold bg-red-700 px-3 py-1 rounded-md text-red-300 shadow"))
          end
        else
          concat(content_tag(:tt, "#{value.first(5)}...", class: "font-bold bg-gray-700 px-3 py-1 rounded-md text-sky-300 shadow"))
        end
      else
        concat(content_tag(:span, "Not set", class: "text-gray-500 italic"))
      end
    end
  end
end
