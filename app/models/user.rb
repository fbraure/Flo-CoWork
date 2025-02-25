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
  scope :pendings, -> { includes(:requests).where( requests: { active: true, progress: [:unconfirmed, :confirmed] } ) }
  scope :pendings_or_expired, -> { includes(:requests).where( requests: { active: true, progress: [:unconfirmed, :confirmed, :expired] } ) }
  scope :contract_accepteds, -> { where( contract_accepted: true ) }

  accepts_nested_attributes_for :requests, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "10 chiffres sans espace" }
  validates :biography, length: { minimum: MIN_BIOGRAPHY_LENGTH , maximum: MAX_BIOGRAPHY_LENGTH }

  after_create :create_unconfirmed_request
  after_update :create_confirmed_request, if: [:saved_change_to_confirmed_at?, :confirmed_at?]
  after_update :set_contract_last_date, if: :saved_change_to_contract_accepted?

  delegate :unconfirmed?, :accepted?, :expired?, to: :active_request

  def pending? = !admin? && active_request&.pending?

  # Le status passe en expired, on prévient pas mail. Un pop-up à la connexion réactive.
  def unconfirm!
    UserMailer.with(user: self).reconfirmation_instructions.deliver_now
    create_expired_request
  end

  # Le statu passe en accept, le contrat passe en not_accepted on prévient pas mail. Un pop-up à la connexion valide le contrat.
  def accept!
    active_request&.accept!
    self.update(contract_accepted: false)
    UserMailer.with(user: self).accept_cowork_contract.deliver_now
  end

  # Le contrat passe en not_accepted, on prévient pas mail. Un pop-up à la connexion valide le contrat.
  def unaccept!
    self.update(contract_accepted: false)
    UserMailer.with(user: self).confirm_cowork_contract.deliver_now
  end

  def get_pending_position
    (User.not_admin
         .pendings_or_expired
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
