# frozen_string_literal: true

module StyleHelper
  # When appending to the primary and secondary button classes, you MUST override the default
  #   padding classes (px-# py-#) to ensure consistent padding within the buttons.
  def primary_btn_classes(append_classes = 'px-5 py-3')
    "btn #{append_classes} text-base font-medium text-white bg-gradient-to-br from-green-400 to-blue-600 "\
      'hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 dark:focus:ring-green-800 '\
      'font-medium rounded-lg text-sm text-center me-2 mb-2'
  end

  # When appending to the primary and secondary button classes, you MUST override the default
  #   padding classes (px-# py-#) to ensure consistent padding within the buttons.
  def secondary_btn_classes(append_classes = 'px-5 py-3', style: :default)
    append_classes = append_classes.split(' ').append(
      'hover:text-white border focus:ring-4 focus:outline-none',
      'font-medium rounded-lg text-sm text-center me-2 mb-2',
      'dark:hover:text-white'
    )
    case style
      when :danger
        append_classes.append(
          'text-red-700 border-red-700 hover:bg-red-800 focus:ring-red-300',
          'dark:border-red-500 dark:text-red-500 dark:hover:bg-red-600 dark:focus:ring-red-900'
        ).join(' ')
      else
        append_classes.append(
          'text-gray-800 border-gray-800 hover:bg-gray-900 focus:ring-gray-300',
          'dark:border-gray-600 dark:text-gray-400 dark:hover:bg-gray-600 dark:focus:ring-gray-800'
        ).join(' ')
    end
  end

  def secondary_danger_btn_classes(append_classes = 'px-5 py-3')
    "text-red-700 #{append_classes} hover:text-white border border-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2 dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
  end
end
