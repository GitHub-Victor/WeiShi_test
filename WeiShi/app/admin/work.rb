ActiveAdmin.register Work do

  filter :weshi_user_id
  filter :work_links
  filter :user, collection: proc { User.accessible_by(current_ability) }, as: :select
  filter :category_id_in, collection: proc{ 
    category = current_user.category.try(:self_and_descendants)
    category = Category.all if current_user.has_role?(:superadmin)
    category.map {|i| ["#{'-' * i.level} #{i.name}" ,i.id] } }, as: :select, :label => "学校"
  filter :status, as: :select, collection: Status.select_options
  filter :created_at

  # select the processing wiki;
  before_filter :only => [:index] do
    if not params[:commit].blank? and not params[:q].blank?
      # 设置搜索分类以下
      if not params[:q][:category_id_in].blank?
        params[:q][:category_id_in] = Category.find(params[:q][:category_id_in]).self_and_descendants.map(&:id)
      end
    end
  end

  index do
    selectable_column
    column :id
    column :category
    column :weshi_user_id
    column :work_links do |work|
      link_to work.work_links, work.work_links, :target => "_blank"
    end
    column :user
    column :created_at
    column :status do |work|
      work.status.text
    end
    column :last_check_user
    actions do |work|
      work_user_level = work.try(:user).try(:roles).try(:first).try(:level)
      work_user_level ||= 0
      if work.user != current_user and current_user.roles.first.level > work_user_level
        link = "".html_safe
        if work.status.rejected? or work.status.processing?
          link += link_to t("active_admin.wikis.pass_the_wiki"), pass_admin_work_path(work), :method => :put
        end
        link += " " 
        if work.status.passed? or work.status.processing?
          link += link_to t("active_admin.wikis.reject_the_wiki"), reject_admin_work_path(work), :method => :put
        end 
        link
      end
    end
  end

  csv do
    column :id
    column("学校信息") {|work| work.category.name }
    column :weshi_user_id
    column("链接") {|work| work.work_links }
    column("备注") {|work| work.remark }
    column("录入用户") {|work| work.user.try(:username) }
    column("状态") {|work| work.status.text }
    column("检查用户") {|work| work.last_check_user.try(:username) }
    column("录入时间") {|work| work.created_at }
  end

  show do |work|
    attributes_table do
      row :weshi_user_id
      row :work_links do 
        link_to work.work_links, work.work_links, :target => "_blank"
      end
      row :remark
      row :user
      row :last_check_user
      row :category
      row :created_at
      row :updated_at
    end

  end

  form do |f|
    f.inputs "Details" do
      f.input :weshi_user_id
      f.input :work_links
      f.input :remark
      f.actions
    end
  end

  member_action :pass, :method => :put do
    work = Work.find(params[:id])
    unless work.last_check_user.blank?
      last_level = work.last_check_user.roles.first.level
      if last_level > current_user.roles.first.level
        redirect_to admin_works_path ,:alert => "该信息已被更高等级用户审核过，您不能再审核"
        return 
      end
    end
    work.status = :passed
    work.last_check_user = current_user
    work.save
    redirect_to admin_works_path ,:notice => t("active_admin.invites.pass_tips")
  end

  member_action :reject, :method => :put do
    work = Work.find(params[:id])
    unless work.last_check_user.blank?
      last_level = work.last_check_user.roles.first.level
      if last_level > current_user.roles.first.level
        redirect_to admin_works_path ,:alert => "该信息已被更高等级用户审核过，您不能再审核"
        return 
      end
    end
    work.status = :rejected
    work.last_check_user = current_user
    work.save
    redirect_to admin_works_path ,:alert => t("active_admin.invites.reject_tips")
  end

  controller do
    def create
      super
      @work.user_id = current_user.id
      @work.category_id = current_user.category.id
      @work.save
    end
  end

end
