class Error < StandardError; end

class User < ApplicationRecord
  ADMIN_EMAIL = "admin@depot.com"
  EMAIL_REGEX = /\A[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\z/

  after_commit :send_welcome_email, on: :create
  before_update  :ensure_an_admin_remains
  has_one :address, as: :addressable
  before_destroy :ensure_an_admin_remains

  has_secure_password
  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  validates :email, uniqueness: true, format: { with: EMAIL_REGEX }

  def is_admin?
      role == 'admin'
  end

  private

  def ensure_an_admin_remains
    if email_was == ADMIN_EMAIL
    errors.add(:base, "Admin cannot be changed")
    throw(:abort)
    end
  end


  def send_welcome_email
    # Will be added later
  end
end
