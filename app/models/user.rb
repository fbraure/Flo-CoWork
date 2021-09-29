class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  MIN_BIOGRAPHY_LENGTH = 20
  MAX_BIOGRAPHY_LENGTH = 5000

  has_many :requests, dependent: :destroy

  scope :not_admin, -> { where( admin: false ) }
  scope :accepteds, -> { includes(:requests).where( requests: { active: true, progress: :accepted } ) }
  scope :not_accepteds, -> { where.not(id: accepteds) }

  accepts_nested_attributes_for :requests, allow_destroy: true

  validates :name, presence: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "10 chiffres sans espace" }
  validates :biography,  length: { minimum: MIN_BIOGRAPHY_LENGTH , maximum: MAX_BIOGRAPHY_LENGTH }

  def active_request
    requests.actives.first
  end

end
