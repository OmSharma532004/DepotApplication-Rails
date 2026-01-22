class Product < ApplicationRecord
  scope :is_enabled, -> { where( enabled: true )}
  IMAGE_EXTENSION_REGEX = /\A.*\.(gif|jpg|png)\z/i

  # Scope for all enabled products
  scope :all_enabled_products, -> { where(enabled: true) }


  DEFAULT_TITLE = "abc"

  # Set title to 'abc'
  after_initialize :set_default_title, if: ->() { new_record? && title.blank? }
  # set discount_price to price if not specified
  after_initialize :set_discount_price, if: -> () { new_record? && discount_price.blank? }

  PERMALINK_REGEX = /\A[a-zA-Z0-9]+(-[a-zA-Z0-9]+){2,}\z/


  belongs_to :category, counter_cache: true


  MAX_IMAGES = 3

  belongs_to :category, dependent: :destroy
  has_many_attached :images

  # Ensures presence for essential attributes
  validates :title, :description, presence: true

  validate :images_count_within_limit

  # Ensures title is unique
  validates :title, uniqueness: true

  # Validates price to be a number and greater than or equal to $0.01
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  has_many :line_items, dependent: :restrict_with_error # add error trying to destroy a product that is assigned to a line_item
  has_many :cart, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item # cascade on delete

after_create_commit  :increment_category_counters
after_destroy_commit :decrement_category_counters
after_update_commit  :handle_category_change

private

def increment_category_counters
  category.parent&.increment!(:products_count)
end

def decrement_category_counters
  category.parent&.decrement!(:products_count)
end

def handle_category_change
  return unless saved_change_to_category_id?

  old_id, new_id = saved_change_to_category_id

  old_category = Category.find(old_id)
  new_category = Category.find(new_id)

  old_category.parent&.decrement!(:products_count)
  new_category.parent&.increment!(:products_count)
end

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end


  def set_default_title
    self.title = DEFAULT_TITLE
  end

  def images_count_within_limit
    return unless images.attached?

    if images.count > MAX_IMAGES
      errors.add(:images, "cannot have more than #{MAX_IMAGES} images")
    end
  end


  def set_discount_price
    self.discount_price = price
  end
end
