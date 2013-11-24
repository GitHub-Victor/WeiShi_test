# -*- encoding : utf-8 -*-
module Wechat::WikisHelper

  def link_to_keyword(keyword)
    link_to keyword, wechat_wikis_search_path(:school => params[:school], :search => {:title_contains => keyword})
  end

  # 获得最顶层分类
  def get_top_categories(wiki_categories)
    wiki_categories.select {|category| category.level == 0}
  end

  # 取得第二级分类
  def get_second_categories(top_category)
    top_category.children.select {|category| category.level == 1}
  end
  
end
