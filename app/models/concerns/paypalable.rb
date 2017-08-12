module Paypalable
  extend ActiveSupport::Concern

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal/paypal_cert.pem")
  APP_CERT_PEM    = File.read("#{Rails.root}/certs/paypal/app_cert.pem")
  APP_KEY_PEM     = File.read("#{Rails.root}/certs/paypal/app_key.pem")

  def paypal_encrypted(return_url)
    values = {
      business:      ENV['paypal_email'],
      cmd:           '_cart',
      charset:       'UTF-8',
      currency_code: 'USD',
      upload:        1,
      return:        return_url,
      invoice:       guid,
      notify_url:    paypal_ipn_url,
      cert_id:       ENV['paypal_cert_id'],
      image_url:     "https://#{ENV['app_url']}/logo_paypal.jpg"
    }

    item_index = 1

    line_items.approved.sorted.each do |li|
      values.merge!({
        "amount_#{item_index}" => li.unit_price.to_f.round(2).to_s,
        "item_name_#{item_index}" => "#{li.product_name} (#{li.kwk_sale_name}) in #{li.variant_name}",
        "quantity_#{item_index}" => 1
      })
      item_index += 1
    end

    values.merge!({
      "amount_#{item_index}" => shipping_total.to_f.round(2).to_s,
      "item_name_#{item_index}" => "Shipping",

      "amount_#{item_index+1}" => donation_amount.to_f.round(2).to_s,
      "item_name_#{item_index+1}" => "Donation",

      "amount_#{item_index+2}" => fee_total.to_f.round(2).to_s,
      "item_name_#{item_index+2}" => "Handling"
    })

    puts values

    encrypt_for_paypal(values)
  end

  def encrypt_for_paypal(values)
    @paypal_cert ||= OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)
    @app_cert    ||= OpenSSL::X509::Certificate.new(APP_CERT_PEM)
    @app_pem     ||= OpenSSL::PKey::RSA.new(APP_KEY_PEM, '')

    signed = OpenSSL::PKCS7::sign(
      @app_cert,
      @app_pem,
      values.map { |k, v| "#{k}=#{v}" }.join("\n"), 
      [], 
      OpenSSL::PKCS7::BINARY
    )

    OpenSSL::PKCS7::encrypt(
      [@paypal_cert],
      signed.to_der, 
      OpenSSL::Cipher::Cipher::new("DES3"), 
      OpenSSL::PKCS7::BINARY
    ).to_s.gsub("\n", "")
  end

  def paypal_ipn_url
    "#{ENV['paypal_ipn_url']}/paypal_ipn/receiver?secret=#{ENV['paypal_secret']}"
  end

end