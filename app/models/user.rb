class Error < StandardError; end

class User < ApplicationRecord
  EMAIL_REGEX = /\A[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\z/

  after_destroy :ensure_an_admin_remains
  has_secure_password

  validates :email, uniqueness: true, format: { with: EMAIL_REGEX }

  private

def ensure_an_admin_remains
  if User.count.zero?
    raise Error.new("Can't delete last user")
  end
end
end
