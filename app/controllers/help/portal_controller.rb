class Help::PortalController < ApplicationController

  def index
    @popular_faqs = Faq.popular.limit(5)
  end

end
