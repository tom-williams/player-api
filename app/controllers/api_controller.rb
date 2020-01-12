class ApiController < ApplicationController
  before_action :authenticate_player!
  include HttpAcceptLanguage::AutoLocale
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  respond_to :json

  def must_be_signed_in
    if !player_signed_in?
      render_unauthorized("Must be logged in")
      return
    end
  end

  def render_not_found_response
    render json: { data: nil, status: "Not found" }, status: :not_found
  end

  def render_unauthorized(message, code = :unauthorized)
    render :json => { data: nil, status: message }, status: code
  end
end