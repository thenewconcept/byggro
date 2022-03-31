module ApplicationHelper

  def format_hours(_hours)
    total_seconds = (_hours*60*60).round # to avoid fractional seconds potentially compounding and messing up seconds, minutes and hours
    hours = total_seconds / (60*60)
    minutes = (total_seconds / 60) % 60 # the modulo operator (%) gives the remainder when leftside is divided by rightside. Ex: 121 % 60 = 1
    seconds = total_seconds % 60
    [hours, minutes].map { |t| t.round.to_s.rjust(2,'0') }.join(':')
  end

  def icon_text(text, icon, options={})
    tag_options = options[:tag_options] || {}
    icon_options = options[:icon_options] || {}
    tag.span **tag_options do
      heroicon(icon, **icon_options) + text
    end
  end

end
