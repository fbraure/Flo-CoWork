class Request < ApplicationRecord
  belongs_to :user

  # ** Request.unconfirmed - requests for which the email address has not been confirmed
  # ** Request.confirmed - requests in the waiting list
  # ** Request.accepted - requests that have been accepted by the client
  # ** Request.expired - requests that have not been reconfirmed
  enum progress: {unconfirmed: 0, confirmed: 1, accepted: 2, expired: 3 }

  after_create :set_lastest_step_active
  after_create :set_user_contract_accepted_false, if: :accepted?

  scope :actives, -> { where( active: true ) }
  scope :order_by_created_at_asc, -> { order(created_at: :desc) }

  # TODO A refaire avec AASM
  def accept! = self.user.create_accepted_request

  def pending? = [:unconfirmed, :confirmed].include?(progress.to_sym)

  def self.stats = actives.order(:progress).pluck(:progress).tally

  private

  def set_lastest_step_active
    self.user.requests.actives.update_all(active: false)
    self.update(active: true)
  end

  def set_user_contract_accepted_false
    self.user.update(contract_accepted: false)
  end
end
