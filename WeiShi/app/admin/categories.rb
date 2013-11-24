ActiveAdmin.register Category do

  filter :name

  # Sort categories by left asc
  config.sort_order = 'lft_asc'

  # Add member actions for positioning.
  sortable_tree_member_actions

  index do
    selectable_column
    # This adds columns for moving up, down, top and bottom.
    column :name do |category|
      "#{'---' * category.level} #{category.name}"
    end
    column :user
    default_actions
  end

  form do |f|
    @category = current_user.category.try(:self_and_descendants)
    @category = Category.all if current_user.has_role?(:superadmin)
    f.inputs "Details" do
      f.input :parent_id, as: :select, :collection => @category.map {|i| ["#{'-' * i.level} #{i.name}" ,i.id] }, :include_blank => proc{ current_user.has_role?(:superadmin) }.call
      f.input :name
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :name
      row :parent_id
      row :user_id
      row :created_at
    end
  end

  controller do
    
    permit_all_params
    
    def create
      super
      @category.user_id = current_user.id
      @category.save
    end

  end

end
