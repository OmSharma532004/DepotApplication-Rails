class PriceValidator < ActiveModel::Validator
  def validate(record)
    return if record.price.blank? || record.discount_price.blank?

    unless record.price > record.discount_price
      record.errors.add :price, (options[:message] || "price less than discount price.")
    end
  end
end
