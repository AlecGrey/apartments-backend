class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :apartment, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
