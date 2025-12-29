class Error < StandardError; end

class User < ApplicationRecord
  EMAIL_REGEX = /\A[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\z/

  after_commit :send_welcome_email, on: :create
  before_update  :protect_admin
  before_destroy :protect_admin
  has_secure_password

  private

  def protect_admin
    if email_was == "admin@depot.com"
    errors.add(:base, 'Admin cannot be changed')
    throw(:abort)
    end
  end

  def send_welcome_email
    Rails.logger.info "User Created Sending Email"
  end
end
