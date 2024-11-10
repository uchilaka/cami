# frozen_string_literal: true

module Navbar
  module V2Helper
    include NavbarHelper

    def navbar_version
      '2.0'
    end

    def current_path
      request.fullpath
    end

    def navbar_link_classes(is_current_page: false)
      if is_current_page
        return 'block py-2 px-3 text-white bg-blue-700 rounded md:bg-transparent md:text-blue-700 md:p-0'\
          ' md:dark:text-blue-500'
      end

      'block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0'\
        ' dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white'\
        ' md:dark:hover:bg-transparent dark:border-gray-700'
    end

    def profile_link_classes
      'block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600'\
        ' dark:text-gray-200 dark:hover:text-white'
    end
  end
end
