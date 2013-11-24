# encoding: utf-8
ActiveAdmin.register User do

  filter :id
  filter :username
  filter :email
  filter :nickname
  filter :last_sign_in_at
  filter :created_at
  filter :role_ids, collection: proc { Role.accessible_by(current_ability) }, as: :select

  form :partial => "form"

  index do
    selectable_column
    column :id
    column :username
    column :email
    column :nickname
    column :last_sign_in_at
    column :created_at
    column :role_ids do |user|
      user.get_role_names
    end
    column :category_id do |user|
      user.category.try(:name)
    end
    default_actions
  end

  show do |user|
      attributes_table do
        row :username
        row :email
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :category_id do
          user.category
        end
        row :role_ids do
          user.get_role_names
        end
      end
  end

  # modify controller to override that edit method.
  # support to not change user passowrd
  controller do
    def update
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
            params[:user].delete(:password)
            params[:user].delete(:password_confirmation)
        end
        super
    end
  end

end
