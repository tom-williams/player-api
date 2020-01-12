class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable,
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :validatable,
      :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :followers, class_name: 'Player', foreign_key: 'followed_id'
  belongs_to :followed, class_name: 'Player', optional: true

  # Email presence and validity checked by devise :validatable
  # https://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Validatable
  validates :firstname, :lastname, presence: true

  def name
    [firstname, lastname].reject(&:blank?).join(" ")
  end

  acts_as_api
  include Definitions::Player
end
