class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true

    validates :state, :city, :country, :pincode, presence: true
end
