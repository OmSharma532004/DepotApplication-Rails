class CreateExampleTable < ActiveRecord::Migration[8.1]
  def change
    create_table :example_tables do |t|
      t.timestamps
    end
  end
end
