  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:legal]

    def home
      @user = current_user
      users = User.not_admin.order_by_created_at_asc
      @accepted_users = User.not_admin.accepteds
      @pending_users = users.pendings
      @expired_users = users.expireds

    end

    def legal
      @page = Page.find_by(title: "Mentions Légales")
    end
  end