# encoding: utf-8
class Category < ActiveRecord::Base
  
  # gem 'strong_parameters'
  include ActiveModel::ForbiddenAttributesProtection

  # gem 'the_sortable_tree' requires
  include TheSortableTree::Scopes

  # gem 'awesome_nested_set' requires
  acts_as_nested_set

  # belongs to user.
  belongs_to :user

  # gem 'awesome_nested_set' requires
  default_scope :order => 'lft ASC'
  attr_accessible :lft, :name, :parent_id, :rgt, :user_id, :can_edit, :depth

  # validates for name and school.
  validates :name, :presence => true

end
