class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork')
  end

  def reconfirmation_instructions
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork - Renouvellement de motivation')
  end

  def accept_cowork_contract
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork - Pensez à signer le contrat')
  end

  def confirm_cowork_contract
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue au Cowork - Pensez à confirmer le contrat')
  end
end