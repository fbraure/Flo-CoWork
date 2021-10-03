class RequestsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    user.requests.create(request_params)
    redirect_to root_path
  end

  private

  def request_params
    params.require(:request).permit(:progress, :active)
  end
end