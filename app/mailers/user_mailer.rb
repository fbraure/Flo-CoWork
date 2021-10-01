class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork')
  end

  def send_reconfirmation_instructions
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: 'Renouvellement de motivation')
  end
end