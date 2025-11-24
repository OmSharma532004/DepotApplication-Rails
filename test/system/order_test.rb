require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  test "check dynamic fields" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    # No fields visible initially
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    # Selecting Check
    select 'Check', from: 'Pay type'
    assert has_field? 'Routing number'
    assert has_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    # Selecting Credit Card
    select 'Credit card', from: 'Pay type'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_field? 'Credit card number'
    assert has_field? 'Expiration date'
    assert has_no_field? 'Po number'

    # Selecting Purchase Order
    select 'Purchase order', from: 'Pay type'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_field? 'Po number'
  end
end
