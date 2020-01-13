class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable,
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :validatable,
      :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow"
  has_many :followers, through: :follower_follows, source: :follower

  has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"
  has_many :followees, through: :followee_follows, source: :followee

  # Email presence and validity checked by devise :validatable
  # https://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Validatable
  validates :firstname, :lastname, presence: true

  def name
    [firstname, lastname].reject(&:blank?).join(" ")
  end

  acts_as_api
  include Definitions::Player
end
