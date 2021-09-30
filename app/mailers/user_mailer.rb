class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork')
  end
end