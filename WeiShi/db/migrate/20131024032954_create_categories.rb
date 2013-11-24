class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt  
      t.references :user
      t.timestamps
    end
    add_index :categories, :user_id
  end
end
