# DOC:
# modify the default render helper, to support 
# the "can_edit" attribute.
module Manage::EditWikiCategoryTreeHelper
  module Render 
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options

        node = options[:node]

        "
          <li id='#{ node.id }_#{ options[:klass] }'>
            <div class='item'>
              #{ show_link }
              #{ controls if node.can_edit  }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        title_field = options[:title]

        "<h4>#{ node.send(title_field) }</h4>"
      end

      def controls
        node = options[:node]

        edit_path = h.url_for(:controller => options[:klass].pluralize, :action => :edit, :id => node)
        show_path = h.url_for(:controller => options[:klass].pluralize, :action => :show, :id => node)

        "
          <div class='controls'>
            #{ h.link_to '', edit_path, :class => :edit }
            #{ h.link_to '', show_path, :class => :delete, :method => :delete, :data => { :confirm => h.t("wiki_category.manage.delete_sure") } }
          </div>
        "
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end