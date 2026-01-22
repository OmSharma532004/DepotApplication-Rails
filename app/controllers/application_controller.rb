class ApplicationController < ActionController::Base
  include CurrentUser
  helper_method :logged_in?, :current_user
  before_action :authorize,:set_i18n_locale_from_params, :count_session_hits, :inactive_logout

  around_action :measure_execution_time
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
