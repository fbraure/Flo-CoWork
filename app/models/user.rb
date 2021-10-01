class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  MIN_BIOGRAPHY_LENGTH = 20
  MAX_BIOGRAPHY_LENGTH = 5000

  has_many :requests, dependent: :destroy
  has_one :active_request, -> { where( active: true ) }, class_name: 'Request'

  scope :not_admin, -> { where( admin: false ) }
  scope :accepteds, -> { includes(:requests).where( requests: { active: true, progress: :accepted } ) }
  scope :confirmeds, -> { includes(:requests).where( requests: { active: true, progress: :confirmed } ) }
  scope :not_accepteds, -> { where.not(id: accepteds) }
  scope :order_by_active_request_created_at_desc, -> {  includes(:active_request).order("active_request.created_at desc") }

  accepts_nested_attributes_for :requests, allow_destroy: true

  validates :name, presence: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "10 chiffres sans espace" }
  validates :biography, length: { minimum: MIN_BIOGRAPHY_LENGTH , maximum: MAX_BIOGRAPHY_LENGTH }

  after_create :create_unconfirmed_request
  after_update :create_confirmed_request, if: [:saved_change_to_confirmed_at?, :confirmed_at?]

  def ask_for_reconfimation
    self.create_unconfirmed_request
    self.send_confirmation_instructions
  end

  private

  def create_unconfirmed_request
    self.requests.create(progress: :unconfirmed)
  end

  def create_confirmed_request
    self.requests.create(progress: :confirmed)
  end

  def create_accepted_request
    self.requests.create(progress: :accepted)
  end

end
