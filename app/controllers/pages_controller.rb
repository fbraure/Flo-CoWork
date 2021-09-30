  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:legal]

    def home
      @accepted_users = User.not_admin.accepteds
      @not_accepted_users = User.not_admin.not_accepteds
    end

    def legal
      @page = Page.find_by(title: "Mentions Légales")
    end
  end