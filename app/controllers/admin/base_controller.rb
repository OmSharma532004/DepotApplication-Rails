class Admin::BaseController < ApplicationController
    before_action :ensure_admin

    
    private

    def ensure_admin
      unless current_user.is_admin?
        redirect_to login_url, notice: "You don't have privilege to access this section"
      end
    end


    def current_user
        @user ||= User.find_by(id: session[:user_id])
    end
end