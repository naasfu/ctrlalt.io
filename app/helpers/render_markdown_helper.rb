module RenderMarkdownHelper
  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(safe_links_only: true, no_styles: true, filter_html: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, space_after_headers: true)

    raw markdown.render(text) unless text.nil?
  end
end
