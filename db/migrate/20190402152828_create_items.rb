class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.integer :quantity
      t.float :price
      t.boolean :enabled
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end