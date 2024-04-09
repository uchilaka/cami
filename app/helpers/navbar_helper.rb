# frozen_string_literal: true

module NavbarHelper
  def navbar_version
    '1.0'
  end

  def profile_name
    @profile_name ||= current_user.nickname || current_user.given_name || current_user.email
  end

  def profile_email
    @profile_email ||= current_user.email
  end

  def profile_photo_url
    return current_user.profile.image_url if user_signed_in?

    image_url 'person-default.svg'
  end

  def show_admin_menu?
    user_signed_in? || Rails.env.development?
  end

  def main_menu
    # TODO: Internationalize these link labels
    # TODO: Include accessibility information for screen readers
    #  and other assistive technologies
    # TODO: Include icon classes for each link
    # TODO: Use pundit policy to determine which links to display
    # TODO: Memoize and return as @main_menu after policy checks
    # TODO: Cache this menu in Redis for 1 hour
    @main_menu ||= [
      { label: t('shared.navbar.home'), path: root_path, public: true },
      { label: t('shared.navbar.dashboard'), path: pages_dashboard_path },
      { label: t('shared.navbar.accounts'), path: accounts_path },
      # { label: t('shared.navbar.services'), path: services_path, public: true },
      # TODO: Eventually take products off this list - intended navigation
      #   is to traverse via services to the component products
      # { label: t('shared.navbar.products'), path: products_path, public: true },
    ]
  end

  def public_menu
    @public_menu ||= main_menu.filter { |item| item[:public] == true }
  end

  def admin_menu
    @admin_menu ||= [
      { label: 'Features', path: '/admin/flipper', admin: true },
      { label: 'Sidekiq', path: '/admin/sidekiq', admin: true },
    ]
  end
end
