class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :weshi_user_id
      t.string :work_links
      t.string :status, :default => :processing
      t.text :remark
      t.integer :category_id
      t.integer :user_id
      t.integer :last_check_user_id

      t.timestamps
    end
  end
end
