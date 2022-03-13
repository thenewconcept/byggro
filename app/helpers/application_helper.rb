module ApplicationHelper

  def icon_text(text, icon, options={})
    tag_options = options[:tag_options] || {}
    icon_options = options[:icon_options] || {}
    tag.span **tag_options do
      heroicon(icon, **icon_options) + text
    end
  end

end
