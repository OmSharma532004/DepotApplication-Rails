json.extract! product,:id, :title
json.category product.category&.name
  def sub_category_products
    Product.where(category_id: sub_categories.select(:id))
  end
