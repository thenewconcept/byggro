module ProjectsHelper
  def tab_classes(active = false)
    active_classes  = 'border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    default_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    active ? active_classes : default_classes
  end

  def active_tab(active)
    active_classes = 'bg-red-500'
    default_classes = 'bg-trasparent'
    active ? active_classes : default_classes
  end

  def icon_badge(text, icon, **options)
    options[:class].concat(' inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border-2')
    tag.p **options do
      heroicon(icon, variant: :outline, options: { class: 'h-3 w-3 mr-1' }) + ' ' + text
    end 
  end

  def status_badge(status)
    case status
    when 'draft'
      color = 'slate'; icon = 'eye-off'
    when 'upcoming'                                 
      color = 'red'; icon = 'calendar'              
    when 'started'                                  
      color = 'yellow'; icon = 'clock'              
    when 'completed'
      color = 'green'; icon = 'check'
    end

    icon_badge(t("project.status.#{status}"), icon, class: color)
  end

end
