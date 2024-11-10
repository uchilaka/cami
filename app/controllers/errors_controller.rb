# frozen_string_literal: true

class ErrorsController < ApplicationController
  # TODO: How does this impact analytics? E.g. reporting to tools like Heap that the
  #   customer experienced an error?
  protect_from_forgery with: :null_session

  rescue_from ActionController::RoutingError, with: :emit_routing_exception
  rescue_from LarCity::Errors::ElevatedPrivilegesRequired, with: :forbidden
  rescue_from LarCity::Errors::UnprocessableEntity, with: :unprocessable_entity
  rescue_from LarCity::Errors::InternalServerError, with: :server_error
  rescue_from LarCity::Errors::ResourceNotFound, with: :not_found

  def emit_routing_exception
    if %r{/admin/}.match?(request.fullpath)
      raise LarCity::Errors::ElevatedPrivilegesRequired if request.params[:unmatched].present?

      raise LarCity::Errors::UnprocessableEntity
    end

    raise LarCity::Errors::ResourceNotFound
  end

  def unprocessable_entity
    render 'errors/unprocessable_entity', status: :unprocessable_entity
  end

  def not_found
    render 'errors/not_found', status: :not_found
  end

  def forbidden
    render 'errors/forbidden', status: :forbidden
  end

  def server_error
    render 'errors/server_error', status: :internal_server_error
  end
end
