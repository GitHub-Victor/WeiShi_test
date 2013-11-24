class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :weshi_user_id
      t.text :remark
      t.string :status, :default => :processing
      t.integer :category_id
      t.integer :user_id
      t.integer :last_check_user_id

      t.timestamps
    end
  end
end
