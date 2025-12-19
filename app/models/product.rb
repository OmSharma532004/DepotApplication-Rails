class Product < ApplicationRecord
  IMAGE_EXTENSION_REGEX = /\A.*\.(gif|jpg|png)\z/i
  # Ensures presence for essential attributes
  validates :title, :description, :image_url, presence: true

  # Ensures title is unique
  validates :title, uniqueness: true

  # Validates price to be a number and greater than or equal to $0.01
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  # Validates image_url format (only checks format if image_url is not blank)
  validates :image_url, allow_blank: true, format: {
    with:    IMAGE_EXTENSION_REGEX,
    message: "must be a URL for GIF, JPG or PNG image."
  }

  has_many :line_items, dependent: :restrict_with_error # add error trying to destroy a product that is assigned to a line_item
  has_many :cart, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item # cascade on delete

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end
end
