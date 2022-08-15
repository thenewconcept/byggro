module ApplicationHelper
  def to_float(value)
    value.delete(' ').sub(',', '.').to_f
  end

  def format_hours(_hours)
    total_seconds = (_hours*60*60).round # to avoid fractional seconds potentially compounding and messing up seconds, minutes and hours
    hours = total_seconds / (60*60)
    minutes = (total_seconds / 60) % 60 # the modulo operator (%) gives the remainder when leftside is divided by rightside. Ex: 121 % 60 = 1
    seconds = total_seconds % 60
    [ 
      hours.round.to_s.rjust(1,'0'), 
      minutes.round.to_s.rjust(2,'0')
    ].join(':')
  end

  def icon_text(text, icon, options={})
    tag_options  = options[:tag_options] || {}
    icon_options = options[:icon_options] || { options: { class: '-ml-1 -mt-[2px] h-[18px]' } }
    tag.span **tag_options do
      heroicon(icon, **icon_options) + text
    end
  end

  def initials_for(user)
   return user.full_name.split(' ').map { |n| n[0] }.join.upcase if user.first_name.present? and user.last_name.present?
   return user.first_name[0..2].upcase if user.first_name.present?
   user.email[0..2].upcase
  end

  def avatar_for(user, options={})
    options[:size] ||= 'w-28 h-28'
    options[:font] ||= 'text-5xl'
    if user.avatar.attached?
      image_tag(user.avatar.variant(:thumb), class: "inline-flex items-center justify-center rounded-full #{options[:size]}")
    else
      tag.span class: "inline-flex items-center justify-center rounded-full bg-amber-600 #{options[:size]}" do
        tag.span initials_for(user), class: "#{options[:font]} font-medium leading-none text-white"
      end
    end
  end
end
