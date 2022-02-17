module ProjectsHelper
  def tab_classes(active = false)
    active_classes  = 'border-indigo-500 text-indigo-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    default_classes = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
    active ? active_classes : default_classes
  end
end
