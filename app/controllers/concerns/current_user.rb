module CurrentUser
    INACTIVITY_TIMEOUT = 5
    
  def measure_execution_time
      start_time = Time.now
      yield
      end_time = Time.now
      duration = end_time - start_time
      response.headers['x-responded-in'] = "#{duration}"
  end

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

    if current_user.last_activity &&
       Time.current - current_user.last_activity >= INACTIVITY_TIMEOUT.minutes

      reset_session
      redirect_to login_path, notice: "You were logged out due to inactivity"
    else
      current_user.update_column(:last_activity, Time.current)
    end
  end


  def count_session_hits
    return unless current_user
    current_user.increment!(:hit_count)
  end


  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

end