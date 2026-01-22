module CurrentSession

  def measure_execution_time
      start_time = Time.now
      yield
      end_time = Time.now
      duration = end_time - start_time
      response.headers['x-responded-in'] = "#{duration}"
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