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
end
