class CreditCardLogoPresenter

  def self.call(name)
    brands = ["Visa", "MasterCard", "Discover", "JCB", "Diners Club"]

    logo = if brands.include? name
      %Q[<i class="fa fa-cc-#{name.downcase.strip.gsub(' ', '-')}"></i>]
    elsif name == "American Express"
      '<i class="fa fa-cc-amex"></i>'
    else
      '<i class="fa fa-credit-cart-alt"></i>'
    end

    logo.html_safe
  end

end