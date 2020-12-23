class CreateApartments < ActiveRecord::Migration[6.0]
  def change
    create_table :apartments do |t|
      t.references :neighborhood, null: false, foreign_key: true
      t.integer :price
      t.string :square_feet
      t.string :integer
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
