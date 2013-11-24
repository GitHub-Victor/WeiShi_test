class AddDepthToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :depth, :integer, :default => 0
  end
end
