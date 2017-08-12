class Checkouts::KwkController < ApplicationController

  before_action :ensure_sale_is_ongoing

private

  def ensure_sale_is_ongoing
    redirect_to root_url, error: t("checkouts.no_ongoing_sales") unless current_kwk_sales?
  end

end
