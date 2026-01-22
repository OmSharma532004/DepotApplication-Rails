class Admin::BaseController < ApplicationController
    before_action :isAdmin

    
    private

    def isAdmin
      unless current_user&.role == 'admin'
        redirect_to login_url, notice: "You don't have privilege to access this section"
      end
    end


    def current_user
        @user ||= User.find_by(id: session[:user_id])
    end
end