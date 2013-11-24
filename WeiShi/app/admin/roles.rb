ActiveAdmin.register Role do

  config.filters = false

  index do
    selectable_column
    column :id
    column :name
    column :level
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :level
    end
    f.actions
  end
end
