class AddSlugToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :slug, :string, null: false
    add_index :items, :slug, unique: true
  end
end
