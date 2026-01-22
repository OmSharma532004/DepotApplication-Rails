class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.string :state, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.bigint :pincode, null: false
<<<<<<< HEAD
      t.belongs_to :addressable, polymorphic: true
=======
>>>>>>> 343f093 (Controller Completed)

      t.timestamps
    end
  end
end
