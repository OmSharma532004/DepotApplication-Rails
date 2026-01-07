class Category < ApplicationRecord
  belongs_to :parent,
             class_name: "Category",
             optional: true,
             inverse_of: :sub_categories

  has_many :sub_categories,
           class_name: "Category",
           foreign_key: :parent_id,
           inverse_of: :parent,
           dependent: :destroy

  has_many :products,
           dependent: :restrict_with_error

  has_many :sub_category_products, through: :sub_categories, source: :products,
            dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id }, if: -> { name.present? }

  validate :only_one_level_nesting
  before_destroy :ensure_no_products_in_tree

  private

  def only_one_level_nesting
    if parent&.parent.present?
      errors.add(:base, "Sub-category cannot have child categories")
      throw(:abort)
    end
  end

  def ensure_no_products_in_tree
    if products.exists? || sub_category_products.exists?
      errors.add(:base, "Cannot delete category with associated products")
      throw(:abort)
    end
  end
end
