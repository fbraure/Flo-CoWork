class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    UserMailer.with(user: user).welcome
  end
end