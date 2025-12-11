class PriceValidator < ActiveModel::Validator
  def validate(record)
    unless record.price > record.discount_price
      record.errors.add :price, (options[:message] || "price less than discount price.")
    end
  end
end
