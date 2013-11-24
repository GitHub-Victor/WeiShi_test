class AddColumnsToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :is_follow_pgy, :boolean, default: false
    add_column :invites, :is_has_avatar, :boolean, default: false
    add_column :invites, :home_page, :string
  end
end
