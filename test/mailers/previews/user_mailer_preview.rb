class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    UserMailer.with(user: user).welcome
  end

  def reconfirmation_instructions
    user = User.first
    token = SecureRandom.hex(10)
    UserMailer.with(user: user, token: token).reconfirmation_instructions
  end

  def accept_cowork_contract
    user = User.first
    UserMailer.with(user: user).accept_cowork_contract
  end
end