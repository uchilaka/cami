# frozen_string_literal: true

module NavbarHelper
  def main_menu
    # TODO: Internationalize these link labels
    # TODO: Include accessibility information for screen readers
    #  and other assistive technologies
    # TODO: Include icon classes for each link
    # TODO: Use pundit policy to determine which links to display
    # TODO: Memoize and return as @main_menu after policy checks
    @main_menu ||= [
      { label: t('shared.navbar.home'), path: root_path, public: true },
      { label: t('shared.navbar.dashboard'), path: pages_dashboard_path },
      { label: t('shared.navbar.accounts'), path: accounts_path },
      { label: t('shared.navbar.services'), path: services_path, public: true },
      # TODO: Eventually take products off this list - intended navigation
      #   is to traverse via services to the component products
      { label: t('shared.navbar.products'), path: products_path, public: true }
    ]
  end

  def public_menu
    main_menu.filter { |item| item[:public] == true }
  end
end
