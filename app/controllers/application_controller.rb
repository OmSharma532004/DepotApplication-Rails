class ApplicationController < ActionController::Base
  before_action :authorize,
                :count_session_hits,
                :inactive_logout,
                :set_i18n_locale_from_params,
                :set_user_preferred_language

  around_action :measure_execution_time
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def measure_execution_time
      start_time = Time.now
      yield
      end_time = Time.now

      session[:duration] = end_time - start_time
  end

  def authorize
    unless User.find_by(id: session[:user_id])&.role == 'admin'
      redirect_to login_url, notice: "You don't have privilege to access this section"
    end
  end

  def inactive_logout
    return unless session[:user_id]

    last_activity = session[:last_activity_at]
    if last_activity && (Time.current - last_activity.to_time >= 5.minutes)
    reset_session
    redirect_to login_path, alert: "You were logged out due to inactivity"
    else
      session[:last_activity_at] = Time.current
    end
  end

  def count_session_hits
    session[:hit_count] ||= 0
    session[:hit_count] += 1
  end

  def set_user_preferred_language()
    locale = AppConstants::LOCALE_MAP[User.find_by(id: session[:user_id])&.language] || I18n.default_locale
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
    else
      flash.now[:notice] = "#{locale} translation not available"
        logger.error flash.now[:notice]
    end
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
end
