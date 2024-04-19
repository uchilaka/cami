# frozen_string_literal: true

module ApplicationHelper
  def omniauth_authorize_path(_resource_name, _provider)
    user_google_omniauth_authorize_path
  end

  def page_title
    Rails.application.class.module_parent_name
  end

  def primary_btn_classes
    'btn text-blue-700 hover:text-white border border-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none '\
      'focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2 dark:border-blue-500 '\
        'dark:text-blue-500 dark:hover:text-white dark:hover:bg-blue-500 dark:focus:ring-blue-800'
  end

  def alt_primary_btn_classes
    'btn text-base font-medium px-5 py-3 text-white bg-gradient-to-br from-green-400 to-blue-600 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none '\
      'focus:ring-green-200 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2'
  end

  def secondary_btn_classes
    'text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-4 focus:outline-none '\
      'focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2 dark:border-gray-600 '\
        'dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800'
  end
end
