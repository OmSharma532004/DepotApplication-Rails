class Product < ApplicationRecord
  PERMALINK_REGEX = /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+){2,}\z/

  # Ensures presence for essential attributes
  validates :title, :description, :image_url, presence: true

  # Ensures title is unique
  validates :title, uniqueness: true

  # Validates price to be a number and greater than or equal to $0.01
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  # Validates price to be a number and greater than discount_price
  validates :price,
    numericality: {
      greater_than: :discount_price
    },
    if: -> { price && discount_price }

  validates_with PriceValidator


  # Validates image_url format (only checks format if image_url is not blank)
  validates :image_url, allow_blank: true, url: true

  # Validates PermaLink to be uniuque,minimum 3 words ,seperated by hyphen and no special characters and space
  validates :permalink,
    uniqueness: true,
    format: {
      with: PERMALINK_REGEX,
      message: "must have at least 3 words separated by hyphens and contain only letters and digits"
  }

  validates :description, length: { in: 5..10 }, allow_blank: true


  has_many :line_items # this is basically added to connect with line item
  before_destroy :ensure_not_referenced_by_any_line_item # cascade on delete

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end
end
