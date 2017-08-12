module FlashNotificationHelper
  def flash_notification(text_only = false)
    flash_messages = []
    flash.each do |type, message|
      text = if text_only
        content_tag(:span, raw(message), class: "text-#{type}")
      else
        content_tag(:div, content_tag(:button, raw("&times;"), class: 'close', data: { dismiss: 'alert' })+ raw(message), class: "alert alert-#{type} fade in")
      end

      flash_messages << text if message
    end
    raw(flash_messages.join("\n"))
  end
end
