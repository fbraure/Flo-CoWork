  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:home, :legal]

    def home
    end

    def legal
      @page = Page.find_by(title: "Mentions Légales")
    end
  end
