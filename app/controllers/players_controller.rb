include ActsAsApi::Rendering

class PlayersController < ApiController
  skip_before_action :authenticate_player!, only: [:followers, :create, :show]
  before_action :must_be_signed_in, only: [:followers, :show]

  def followers
    player = Player.find(params[:id])

    limit = params[:limit] || 20
    offset = params[:offset] || 0

    followers = player.followers.order(firstname: :asc, lastname: :asc, created_at: :asc).limit(limit).offset(offset)

    render_for_api :basic, json: followers, :root => :data, meta: { status: nil }
  end

  def show
    player = Player.find(params[:id])

    render_for_api :expanded, json: player, :root => :data, meta: { status: nil }
  end

  def create
    player = Player.create(player_params)

    if player.valid?
      render_for_api :expanded, json: player, :root => :data, meta: { status: nil }
    else
      render json: { data: nil, status: player.errors.full_messages.first }, status: 400
    end
  end

  def update_profile
    current_player.update(player_params)

    if current_player.valid?
      render_for_api :expanded, json: current_player, :root => :data, meta: { status: nil }
    else
      render json: { data: nil, status: current_player.errors.full_messages.first }, status: 400
    end
  end

  def follow
    player_to_follow = Player.find(params[:player_to_follow_id])

    player_to_follow.followers << current_player

    render json: { data: nil, status: nil }, status: 200
  end

  private

  def player_params
    params.permit(
      :firstname,
      :lastname,
      :email,
      :position,
      :club,
      :date_of_birth,
      :password,
      :password_confirmation)
  end
end