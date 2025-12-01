class UrlValidator < ActiveModel::EachValidator
  ExtensionValidationRegex = /\.(gif|jpg|jpeg|png)\z/i

  def validate_each(record, attribute, value)
    unless value =~ ExtensionValidationRegex
      record.errors.add(attribute, options[:message] || "must be a URL for GIF, JPG, JPEG, or PNG image.")
    end
  end
end

class PriceValidator < ActiveModel::Validator
  def validate(record)
    unless record.price > record.discount_price
      record.errors.add :price, (options[:message] || "price less than discount price.")
    end
  end
end
class Product < ApplicationRecord
  # Ensures presence for essential attributes
  validates :title, :description, :image_url, presence: true

  # Ensures title is unique
  validates :title, uniqueness: true

  # Validates price to be a number and greater than discount_price
  validates :price,
    numericality: {
      greater_than: :discount_price
    },
    if: -> { price.present? && discount_price.present? }


  # Validates image_url format (only checks format if image_url is not blank)
  validates :image_url, allow_blank: true, url: true

  # Validates PermaLink to be uniuque,minimum 3 words ,seperated by hyphen and no special characters and space
  validates :permalink,
    uniqueness: true,
    format: {
      with: /\A[a-zA-Z]+(-[a-zA-Z]+){2,}\z/,
      message: "must have at least 3 words separated by hyphens and contain only letters"
  }

  validates :description, length: { in: 5..10 }


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
