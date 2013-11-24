# encoding: utf-8
module Manage::WikiCategoriesHelper

  # 获取一级菜单
  def get_level_top_categories(parent_categories)
    categories = Array.new
    parent_categories.select{|i| i.level == 0 }.each {|category|
        categories << ["#{'-' * category.level} #{category.name}", category.id.to_s]
    }
    categories
  end

end
