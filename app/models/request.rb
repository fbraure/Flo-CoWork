class Request < ApplicationRecord
  belongs_to :user

  # ** Request.unconfirmed - requests for which the email address has not been confirmed
  # ** Request.confirmed - requests in the waiting list
  # ** Request.accepted - requests that have been accepted by the client
  # ** Request.expired - requests that have not been reconfirmed
  enum progress: {unconfirmed: 0, confirmed: 1, accepted: 2, expired: 3 }

  after_create :set_lastest_step_active

  scope :actives, -> { where( active: true ) }
  scope :order_by_created_at_desc, -> { order(created_at: :desc) }

  private

  def set_lastest_step_active
    self.user.requests.actives.update_all(active: false)
    self.update(active: true)
  end
end
