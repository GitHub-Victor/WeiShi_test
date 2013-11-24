# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :superadmin
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        can :manage, :all

    elsif user.has_role? :country_manager
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        can :read, Role, :name => [ :area_manager, :province_manager, :school_manager, :organization_manager ]
        default_admin_can user

    elsif user.has_role? :area_manager
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        can :read, Role, :name => [ :province_manager, :school_manager, :organization_manager ]
        default_admin_can user

    elsif user.has_role? :province_manager
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        can :read, Role, :name => [ :school_manager, :organization_manager ]
        default_admin_can user

    elsif user.has_role? :school_manager
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        can :read, Role, :name => [ :organization_manager ]
        default_admin_can user
        
    elsif user.has_role? :organization_manager
        can :read, ActiveAdmin::Page, :name => "Dashboard" 
        default_admin_can user
    end

  end

  def default_admin_can(user)
    # 取子类及自己
    user_categories_id = user.category.self_and_descendants.map(&:id).uniq
    # 取子类
    user_sub_categories_id = user_categories_id.clone
    user_sub_categories_id.delete user.category.id

    # 能修改自己及旗下节点用户的信息
    can :manage, User, :category_id => user_sub_categories_id
    can :manage, User, :id => user.id
    can :create, User unless user.has_role? (:organization_manager)
    # category
    can :manage, Category, :id => user_categories_id
    can :create, Category
    # invite
    can :read, Invite, :category_id => user_categories_id
        # 能编辑自己还没通过的, 还有自己子类以下的
    can [:update, :destroy], Invite, { :status => :processing, :user_id => user.id }
    can [:update, :destroy], Invite, { :category_id => user_sub_categories_id }
    can [:update, :destroy], Invite if user.has_role? (:superadmin)
    can :create, Invite unless user.has_role? (:superadmin)
    
    # work
    can :read, Work, :category_id => user_categories_id
    # 能编辑自己还没通过的, 还有自己子类以下的
    can [:update, :destroy], Work, { :status => :processing, :user_id => user.id }
    can [:update, :destroy], Work, { :category_id => user_sub_categories_id }
    can [:update, :destroy], Work if user.has_role? (:superadmin)
    can :create, Work unless user.has_role? (:superadmin)
  end
end
