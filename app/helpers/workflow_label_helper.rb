module WorkflowLabelHelper
  def workflow_label(order)
    current_state = order.current_state.to_s
    content_tag :span, current_state.humanize.upcase, class: "label label-#{current_state}"
  end
end
