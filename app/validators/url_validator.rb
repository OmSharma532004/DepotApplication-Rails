class UrlValidator < ActiveModel::EachValidator
  IMAGE_EXT_REGEX = /\Ahttps?:\/\/.+\.(gif|jpg|jpeg|png)(\?.*)?\z/i

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.match?(IMAGE_EXT_REGEX)
      record.errors.add(attribute, options[:message] || "must be a valid image URL")
    end
  end
end
