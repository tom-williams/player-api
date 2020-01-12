require 'devise/jwt/test_helpers'

def log_in(player)
  sign_in(player)
  session[:player_id] = player.id
end

def get_authorization_header(player)
  Devise::JWT::TestHelpers.auth_headers({}, player)["Authorization"]
end
