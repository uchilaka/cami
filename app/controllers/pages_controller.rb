# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  load_console :home, :dashboard

  def app; end

  def dashboard; end

  def home; end
end
