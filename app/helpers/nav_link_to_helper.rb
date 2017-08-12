module NavLinkToHelper  
  def nav_link_to(text, link, options = {})
    active_class = current_page?(link) ? 'active' : nil
    content_tag :li, class: active_class do
      link_to text.html_safe, link, options
    end
  end
end
