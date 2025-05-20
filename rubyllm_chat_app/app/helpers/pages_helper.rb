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
end
