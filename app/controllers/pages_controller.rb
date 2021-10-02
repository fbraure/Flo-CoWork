  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:legal]

    def home
      @user = current_user
      @accepted_users = User.not_admin.accepteds
      @pending_users = User.not_admin
                           .pendings
                           .order_by_created_at_asc
    end

    def legal
      @page = Page.find_by(title: "Mentions Légales")
    end
  end