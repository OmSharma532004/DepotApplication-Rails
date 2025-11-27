require "test_helper"

# these test are basically to test your validations on model are they working correctly or not

class ProductTest < ActiveSupport::TestCase
  fixtures :products # loads some test data to test upon
  test "product price must be positive" do
  product = Product.new(
    title: "My Book Title",
    description: "yyy",
    image_url: "zzz.jpg"
  )

  product.price = -1
  assert product.invalid? # as in our validations this will give true
  assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]

  product.price = 0
  assert product.invalid?
  assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]

  product.price = 1
  assert product.valid? # our validations will return true for this as well
end
# this test passes on our validations
# if there was some issue with our model validations then this test
# won't pass. this means on entering invalid dummy data our validations on model
# are returning false

def new_product(image_url)
  Product.new(
    title: "My Book Title",
    description: "yyy",
    price: 1,
    image_url: image_url
  )
end

test "image url" do
  ok = %w[
    fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
    http://a.b.c/x/y/z/fred.gif
  ]

  bad = %w[
    fred.doc fred.gif/more fred.gif.more
  ]

  ok.each do |image_url|
    assert new_product(image_url).valid?, "#{image_url} must be valid"
  end

  bad.each do |image_url|
    assert new_product(image_url).invalid?, "#{image_url} must be invalid"
  end
end

test "product is not valid without a unique title" do
  product = Product.new(
    title:       products(:ruby).title,   # duplicate title (ruby is name here of entry)
    description: "yyy",
    price:       1,
    image_url:   "fred.gif"
  )

  assert product.invalid?
  assert_equal [ "has already been taken" ], product.errors[:title]
end

test "can't delete product in cart" do
  assert_difference("Product.count", 0) do
    delete product_url(products(:two))
  end

  assert_redirected_to products_url
end

test "should destroy product" do
  assert_difference("Product.count", -1) do
    delete product_url(@product)
  end

  assert_redirected_to products_url
end
end


# PS C:\Users\omsha\desktop\work\depot> rails test:models

# Running 3 tests in a single process (parallelization threshold is 50)
# Run options: --seed 64943

# Finished in 0.460390s, 6.5162 runs/s, 34.7531 assertions/s.
# 3 runs, 16 assertions, 0 failures, 0 errors, 0 skips
# all the tests run like this this means are validations on database are correct
