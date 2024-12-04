# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  load_console :home, :dashboard

  def home; end

  def dashboard; end
end
