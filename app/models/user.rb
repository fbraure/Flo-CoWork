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
  scope :order_by_created_at_asc, -> { order(created_at: :asc) }
  scope :order_by_active_request_created_at_asc, -> {  includes(:active_request).order("active_request.created_at asc") }
  scope :not_admin, -> { where( admin: [nil, false] ) }
  scope :unconfirmeds, -> { includes(:requests).where( requests: { active: true, progress: :unconfirmed } ) }
  scope :accepteds, -> { includes(:requests).where( requests: { active: true, progress: :accepted } ) }
  scope :confirmeds, -> { includes(:requests).where( requests: { active: true, progress: :confirmed } ) }
  scope :expireds, -> { includes(:requests).where( requests: { active: true, progress: :expired } ) }
  # non accepted, et non expired
  scope :pendings, -> { includes(:requests).where( requests: { active: true, progress: [:unconfirmed, :confirmed] } ) }

  accepts_nested_attributes_for :requests, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "10 chiffres sans espace" }
  validates :biography, length: { minimum: MIN_BIOGRAPHY_LENGTH , maximum: MAX_BIOGRAPHY_LENGTH }

  after_create :create_unconfirmed_request
  after_update :create_confirmed_request, if: [:saved_change_to_confirmed_at?, :confirmed_at?]
  after_update :set_contract_last_date, if: :saved_change_to_contract_accepted?

  def pending? = !admin? && active_request&.pending?
  def unconfirmed? = active_request&.unconfirmed?
  def confirmed? = active_request&.confirmed?
  def accepted? = active_request&.accepted?
  def expired? = active_request&.expired?
  def accept! = active_request&.accept!

  # Le status passe en expired, on prévient pas mail. Un pop-up à la connexion réactive.
  def unconfirm
    create_expired_request
    unless @raw_confirmation_token
      generate_confirmation_token!
    end
    UserMailer.with(user: self).reconfirmation_instructions.deliver_now
  end

  # Le contrat passe en not_accepted, on prévient pas mail. Un pop-up à la connexion réactive.
  def unaccept
    self.update(contract_accepted: false)
    UserMailer.with(user: self).accept_cowork_contract.deliver_now
  end

  def get_pending_position
    (User.not_admin
         .pendings
         .order_by_created_at_asc
         .map(&:id).index(self.id) || 0 ) + 1
  end

  def create_unconfirmed_request = self.requests.create(progress: :unconfirmed)
  def create_confirmed_request   = self.requests.create(progress: :confirmed)
  def create_accepted_request    = self.requests.create(progress: :accepted)
  def create_expired_request     = self.requests.create(progress: :expired)

  private

  def set_contract_last_date
    self.update(contract_last_date: DateTime.current)
  end

end
