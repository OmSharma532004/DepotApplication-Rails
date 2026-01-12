class Error < StandardError; end

class User < ApplicationRecord
  belongs_to :address, optional: true
  after_destroy :ensure_an_admin_remains
  has_secure_password
  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  private

def ensure_an_admin_remains
  if User.count.zero?
    raise Error.new("Can't delete last user")
  end
end
end
