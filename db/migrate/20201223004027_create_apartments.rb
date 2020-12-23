class CreateApartments < ActiveRecord::Migration[6.0]
  def change
    create_table :apartments do |t|
      t.references :neighborhood, null: false, foreign_key: true
      t.integer :price
      t.integer :square_feet
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
