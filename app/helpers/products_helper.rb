module ProductsHelper
  BASE_INPUT_CLASSES = "block shadow-sm rounded-md border px-3 py-2 mt-2 w-full".freeze

  def field_classes(record, attribute)
    if record.errors[attribute].any?
      "#{BASE_INPUT_CLASSES} border-red-400 focus:outline-red-600"
    else
      "#{BASE_INPUT_CLASSES} border-gray-400 focus:outline-blue-600"
    end
  end
end
