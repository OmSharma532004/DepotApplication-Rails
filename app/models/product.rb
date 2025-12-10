class Product < ApplicationRecord
    IMAGE_EXTENSION_REGEX = /\A.*\.(gif|jpg|png)\z/i
  
    # Set title to 'abc'
  after_initialize :set_title_to_default_after_intitialize, if: ->() {title.blank?}
  # set discount_price to price if not specified
  after_initialize :set_discount_price_to_price, if: -> () {discount_price.blank?}

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

  has_many :line_items # this is basically added to connect with line item
  before_destroy :ensure_not_referenced_by_any_line_item # cascade on delete

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  def set_title_to_default_after_intitialize
      self.title = 'abc'
      puts "Title is updated"
  end

  def set_discount_price_to_price
    if discount_price.blank?
      self.discount_price = price
      puts "Default dicount_price is set"
    end
  end
end
