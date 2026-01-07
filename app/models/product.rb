class Product < ApplicationRecord
  IMAGE_EXTENSION_REGEX = /\A.*\.(gif|jpg|png)\z/i
  belongs_to :category
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


  after_create_commit  :increment_category_counters
  after_destroy_commit :decrement_category_counters
  after_update_commit  :handle_category_change

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  def increment_category_counters
    update_counters(category, 1)
  end

  def decrement_category_counters
    update_counters(category, -1)
  end

  def handle_category_change
    return unless saved_change_to_category_id?

    old_id, new_id = saved_change_to_category_id
    update_counters(Category.find(old_id), -1)
    update_counters(Category.find(new_id), 1)
  end

  def update_counters(category, by)
    category.increment!(:product_count, by)

    if category.parent.present?
      category.parent.increment!(:product_count, by)
    end
  end
end
