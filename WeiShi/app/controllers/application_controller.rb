# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # 验证是否超级管理员
  def authenticate_admin_user!
    admin_access_denied(CanCan::AccessDenied.new) if current_user.blank?
  end

  # 一般越权访问跳转
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  # 后台越权访问跳转
  def admin_access_denied(exception)
    redirect_to user_session_path, :alert => "您没有授权访问该页面"
  end
  
  protected

  # 配置devise permitted 字段
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(*User::ACCESSABLE_ATTRS) }
  end

end
