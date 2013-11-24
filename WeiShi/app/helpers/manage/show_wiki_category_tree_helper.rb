# -*- encoding : utf-8 -*-
# DOC:
# 百科前端管理页面左侧分栏helper
module Manage::ShowWikiCategoryTreeHelper
  class Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options

        node = options[:node]
        url  = get_category_url(node)
        style = "item"
        style << ' item_top_level' if node.level.zero?
        style << " item_selected" if h.current_page?(url)
        "
          <li>
            <div class='#{style}'>
              #{ show_link(url) }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link(url)
        options[:params]
        node = options[:node]
        ns   = options[:namespace]
        title_field = options[:title]
        if node.level == 0
            node.send(title_field)
        else
          "<h4>#{ h.link_to(node.send(title_field), url) }</h4>"
        end
      end

      def children
        unless options[:children].blank?
          "<ol>#{ options[:children] }</ol>"
        end
      end

      private

      # 获得分类链接的url
      def get_category_url(category)
        category_id = get_category_id(category)
        search_option = get_merge_search_params( {:wiki_categories_id_in => category_id} )
        url = h.url_for(search_option)
      end

      def get_category_id(category)
        if category.nil?
          return ""
        else
          return category.id
        end
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
  end
end