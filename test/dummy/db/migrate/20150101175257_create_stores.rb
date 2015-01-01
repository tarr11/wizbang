class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :city
      t.boolean :is_open

      t.timestamps
    end
  end
end
