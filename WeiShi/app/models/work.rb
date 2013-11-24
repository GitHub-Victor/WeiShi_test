class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :last_check_user, class_name: "User", foreign_key: "last_check_user_id"
  attr_accessible :category_id, :last_check_user_id, :remark, :status, :user_id, :weshi_user_id, :work_links
  validates :weshi_user_id, :presence => true
  validates :work_links, :presence => true
  classy_enum_attr :status, default: :processing
end
