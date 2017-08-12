module FormatDeadlineHelper
  def format_deadline(deadline)
    if deadline < Time.zone.now
      content_tag :span, "#{time_ago_in_words deadline} ago", class: "text-danger"
    else
      content_tag :span, "#{distance_of_time_in_words_to_now deadline} left", class: "text-success"
    end
  end
end
