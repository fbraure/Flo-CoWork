class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    UserMailer.with(user: user).welcome
  end

  def send_reconfirmation_instructions
    user = User.first
    token = SecureRandom.hex(10)
    UserMailer.with(user: user, token: token).send_reconfirmation_instructions(user, token)
  end
end