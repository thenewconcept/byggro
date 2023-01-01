# frozen_string_literal: true

module HeroiconHelper
  include Heroicon::Engine.helpers

  def icon_text(text, icon, options={})
    tag_options  = options[:tag_options] || {}
    icon_options = options[:icon_options] || { options: { class: '-ml-1 -mt-[2px] h-[18px]' } }
    tag.span **tag_options do
      heroicon(icon, **icon_options) + text
    end
  end
end