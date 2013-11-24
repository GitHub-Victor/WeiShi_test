# encoding: utf-8
ActiveAdmin.register Invite do

  filter :weshi_user_id
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
    column("学校信息") do |invite|
      invite.user.try(:category).try(:name)
    end
    column :weshi_user_id
    column("关注") do |invite|
      invite.is_follow_pgy.humanize
    end
    column("头像") do |invite|
      invite.is_has_avatar.humanize
    end
    column :home_page do |invite|
      link_to invite.home_page, invite.home_page, :target => "_blank"
    end
    column :user_information
    column :user
    column :created_at
    column :status do |invite|
      invite.status.text
    end
    column :last_check_user
    actions do |invite|
      invite_user_level = invite.try(:user).try(:roles).try(:first).try(:level)
      invite_user_level ||= 0
      if invite.user != current_user and current_user.roles.first.level > invite_user_level
        link = "".html_safe
        if invite.status.rejected? or invite.status.processing?
          link += link_to t("active_admin.wikis.pass_the_wiki"), pass_admin_invite_path(invite), :method => :put
        end
        link += " " 
        if invite.status.passed? or invite.status.processing?
          link += link_to t("active_admin.wikis.reject_the_wiki"), reject_admin_invite_path(invite), :method => :put
        end 
        link
      end
    end
  end

  csv :col_sep => "\t" do
    column :id
    column("学校信息") {|invite| invite.user.category.name }
    column :weshi_user_id
    column("是否关注蒲公英微校园") {|invite| invite.is_follow_pgy }
    column("是否有头像") {|invite| invite.is_has_avatar }
    column("用户主页") {|invite| invite.home_page }
    column("用户信息") {|invite| invite.user_information }
    column("备注") {|invite| invite.remark }
    column("录入用户") {|invite| invite.user.try(:username) }
    column("状态") {|invite| invite.status.text }
    column("检查用户") {|invite| invite.last_check_user.try(:username) }
    column("录入时间") {|invite| invite.created_at }
  end

  show do |invite|
    attributes_table do
      row :weshi_user_id
      row :is_follow_pgy
      row :is_has_avatar
      row :home_page do 
        link_to invite.home_page, invite.home_page, :target => "_blank"
      end
      row :user_information
      row :remark
      row :user
      row :last_check_user
      row("学校信息") do
        invite.user.category
      end
      row :created_at
      row :updated_at
    end

  end

  form do |f|
    f.inputs "Details" do
      f.input :weshi_user_id
      f.input :is_follow_pgy, as: :select, :include_blank => false
      f.input :is_has_avatar, as: :select, :include_blank => false 
      f.input :home_page
      f.input :remark
      f.actions
    end
  end

  member_action :pass, :method => :put do
    invite = Invite.find(params[:id])
    unless invite.last_check_user.blank?
      last_level = invite.last_check_user.roles.first.level
      if last_level > current_user.roles.first.level
        redirect_to admin_invites_path ,:alert => "该信息已被更高等级用户审核过，您不能再审核"
        return 
      end
    end
    invite.status = :passed
    invite.last_check_user = current_user
    invite.save
    redirect_to admin_invites_path ,:notice => t("active_admin.invites.pass_tips")
  end

  member_action :reject, :method => :put do
    @user_level = {
      :superadmin => 4,
      :area_manager => 3,
      :province_manager => 2,
      :school_manager => 1
    }
    invite = Invite.find(params[:id])
    unless invite.last_check_user.blank?
      last_level = invite.last_check_user.roles.first.level
      if last_level > current_user.roles.first.level
        redirect_to admin_invites_path ,:alert => "该信息已被更高等级用户审核过，您不能再审核"
        return 
      end
    end
    invite.status = :rejected
    invite.last_check_user = current_user
    invite.save
    redirect_to admin_invites_path ,:alert => t("active_admin.invites.reject_tips")
  end

  controller do

    # 添加boom头到csv
    def index
      respond_to do |format|
        format.html {super}
        format.xml {super}
        format.json {super}
        format.csv do
          @invites = Invite.accessible_by(current_ability).search(params[:search])
          send_data(@invites.all.to_xls)
        end
      end
    end

    # 给旧的数据补上用户信息
    # def index

    #   Invite.all.each{ |invite|
    #     begin
    #       require 'net/http'
    #       uri = URI("http://pgywxy.com/pgywxy/catch_sb_info.php?url=#{invite.home_page}")
    #       res = Net::HTTP.get_response(uri)
    #       invite.user_information = res.body
    #       invite.save
    #     rescue Exception => e
    #     end
    #   }

    #   super
    # end

    def create
      super
      # 链接获取用户信息API
      begin
        require 'net/http'
        uri = URI("http://pgywxy.com/pgywxy/catch_sb_info.php?url=#{@invite.home_page}")
        res = Net::HTTP.get_response(uri)
        @invite.user_information = res.body
      rescue Exception => e
      end
      @invite.user_id = current_user.id
      @invite.category_id = current_user.category.id
      @invite.save
    end

    def update
      super
      begin
        require 'net/http'
        uri = URI("http://pgywxy.com/pgywxy/catch_sb_info.php?url=#{@invite.home_page}")
        res = Net::HTTP.get_response(uri)
        @invite.user_information = res.body
      rescue Exception => e
      end
      @invite.save
    end

  end

end
