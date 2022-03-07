module ProjectsHelper
  def tab_classes(active = false)
    active_classes  = 'border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    default_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    active ? active_classes : default_classes
  end

  def status_badge(status, **options)
    case status
    when 'upcoming'
      color = 'red'; icon = 'calendar'
    when 'started'
      color = 'yellow'; icon = 'clock'
    when 'completed'
      color = 'green'; icon = 'check'
    end

    tag.p class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-#{color}-100 text-#{color}-800" do
      heroicon(icon, variant: :outline, options: { class: 'h-3 w-3 pr-1 pt-0.5' }) + '' + t("project.status.#{status}")
    end 
  end
# , 
end
