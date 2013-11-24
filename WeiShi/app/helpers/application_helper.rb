module ApplicationHelper

  def navigation_link(label, url, option = {})
    id_name = current_page?(url) ? 'main_page' : ''
    link = link_to label, url, :method=> option[:method], :class => "header_link", :id => id_name
    content_tag(:li, link, :class => "header_text" )
  end

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

end
