class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  MIN_BIOGRAPHY_LENGTH = 20
  MAX_BIOGRAPHY_LENGTH = 5000

  has_many :requests, dependent: :destroy
  has_one :active_request, -> { where( active: true ) }, class_name: 'Request'

  # TODO rails migration date dedicated to store pending start
  scope :order_by_created_at_desc, -> { order(created_at: :desc) }
  scope :order_by_active_request_created_at_desc, -> {  includes(:active_request).order("active_request.created_at desc") }
  scope :not_admin, -> { where( admin: false ) }
  scope :unconfirmeds, -> { includes(:requests).where( requests: { active: true, progress: :unconfirmed } ) }
  scope :accepteds, -> { includes(:requests).where( requests: { active: true, progress: :accepted } ) }
  scope :confirmeds, -> { includes(:requests).where( requests: { active: true, progress: :confirmed } ) }
  # non accepted, et non expired
  scope :pendings, -> { includes(:requests).where( requests: { active: true, progress: [:unconfirmed, :confirmed] } ) }

  accepts_nested_attributes_for :requests, allow_destroy: true

  validates :name, presence: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "10 chiffres sans espace" }
  validates :biography, length: { minimum: MIN_BIOGRAPHY_LENGTH , maximum: MAX_BIOGRAPHY_LENGTH }

  after_create :create_unconfirmed_request
  after_update :create_confirmed_request, if: [:saved_change_to_confirmed_at?, :confirmed_at?]

  def pending?
    active_request&.pending?
  end

  def unconfirm
    create_unconfirmed_request
    unless @raw_confirmation_token
      generate_confirmation_token!
    end
    UserMailer.with(user: self, token: @raw_confirmation_token).send_reconfirmation_instructions.deliver_now
  end

  def get_pending_position
    (User.not_admin
         .pendings
         .order_by_created_at_desc
         .map(&:id).index(self.id) || 0 ) + 1
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
