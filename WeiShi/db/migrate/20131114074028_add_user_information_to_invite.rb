class AddUserInformationToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :user_information, :string
  end
end
