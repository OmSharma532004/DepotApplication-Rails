class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.string :state, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.bigint :pincode, null: false
      t.belongs_to :addressable, polymorphic: true

      t.timestamps
    end
  end
end
