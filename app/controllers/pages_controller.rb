  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:legal]

    def home
      @accepted_users = User.not_admin.accepteds
      @not_accepted_users = User.not_admin
                                .not_accepteds
                                .order_by_active_request_created_at_desc
    end

    def legal
      @page = Page.find_by(title: "Mentions Légales")
    end
  end