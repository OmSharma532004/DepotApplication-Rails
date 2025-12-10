class Error < StandardError; end

class User < ApplicationRecord
  EMAIL_REGEX = /\A[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\z/
  
  after_commit :send_welcome_email ,on: :create
  before_destroy :admin_cannot_be_modified_or_destroyed, if: ->() {email == 'admin@depot.com'}
  before_update :admin_cannot_be_modified_or_destroyed, if: ->() {email == 'admin@depot.com'}
  after_destroy :ensure_an_admin_remains
  has_secure_password

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new("Can't delete last user")
    end
  end

  def admin_cannot_be_modified_or_destroyed
    raise "Admin user cannot be modified or destroyed"
  end

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
