module Authorizable

  def authorize
    unless current_user
      redirect_to login_url, notice: "You don't have privilege to access this section"
    end
  end

  def logged_in?
    current_user.present?
  end

  
  def inactive_logout
    return unless current_user

    if current_user.inactive?
      reset_session
      redirect_to login_path, notice: "You were logged out due to inactivity"
    else
      current_user.update(last_activity: Time.current)
    end
  end


  def count_session_hits
    return unless current_user
    current_user.increment!(:hit_count)
  end


  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

end