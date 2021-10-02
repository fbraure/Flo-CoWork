class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if verify_recaptcha(model: resource)
      super
    else
      flash.discard(:recaptcha_error)
      render 'new'
    end
  end

  protected

  def update_resource(resource, params)
    if params[:password].blank? || params[:password_confirmation].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end
end
