# frozen_string_literal: true

class HealthzController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    render plain: 'OK'
  end
end
