class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :last_check_user, class_name: "User", foreign_key: "last_check_user_id"
  attr_accessible :category_id, :last_check_user_id, :remark, :status, :user_id, :weshi_user_id, :is_follow_pgy, :is_has_avatar, :home_page, :user_information
  classy_enum_attr  :status, default: :processing
  validates :weshi_user_id, :presence => true
  validates :home_page, :presence => true
end
