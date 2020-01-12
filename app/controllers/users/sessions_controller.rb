class Users::SessionsController < Devise::SessionsController
  respond_to :json
  wrap_parameters :player, include: [:email, :password]

  def respond_to_on_destroy
    render json: {
      status: "You are now logged out",
      data: nil
    }, status: :ok
  end

  def respond_with(resource, opts = {})
    data = {
      token: current_token
    }

    render json: {
      status: nil,
      data: data
    }, status: :ok
  end

  private

  def skip_session_cookie
    request.session_options[:skip] = true
  end

  def current_token
    request.env['warden-jwt_auth.token']
  end
end