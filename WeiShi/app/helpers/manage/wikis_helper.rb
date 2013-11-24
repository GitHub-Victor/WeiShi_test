# encoding: utf-8
module Manage::WikisHelper

  # 编辑页面组织分类的方法
  def option_group_form_categories_for_select(categories)
    options = Array.new
    categories.select{|category| category.level == 0}.each{|c|
      sub_options = Array.new
      c.children.each{|sub_category|
        sub_options << [ sub_category.name , sub_category.id ]
      }
      options << [ c.name ,sub_options ]
    }
    options
  end

  def link_wiki_status(status, option = {})
    search_option = get_merge_search_params( {:wiki_status_in => status} )
    option[:label] ||= wiki_status_label(status.to_s)
    url = url_for(search_option)
    if current_page?(url)
      option[:label]
    else
      link_to option[:label], url
    end
  end

  def link_school(school, option ={})
    search_option = get_merge_search_params( {:schools_id_in => school} )
    option[:label] ||= school.name
    url = url_for(search_option)
    cls = "item item_top_school"
    cls << " item_selected" if current_page? url
    content_tag :div ,(content_tag :h4, link_to(option[:label], url)), :class => cls
  end

  private

  def wiki_status_label(status)
    # count = @all_wikis.where(:wiki_status => status).count
    "#{t("classy_enum.wiki_status." + status)}"
  end

  def get_merge_search_params(search_option)
    {:search => search_option}
    # _params = params.clone
    # if not _params[:search].nil?
    #   _params[:search] = _params[:search].merge search_option
    # else
    #   _params[:search] = search_option
    # end
    # _params.try(:delete, :page)
    # _params
  end

end
