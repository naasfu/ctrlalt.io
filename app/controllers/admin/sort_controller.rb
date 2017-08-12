class Admin::SortController < Admin::AdminController
  # POST /admin/sort
  def sort
    class_name = params[:class_name]
    sortable   = params[class_name.to_sym]

    sortable.each_with_index do |id, index|
      class_name.camelize.constantize.where(id: id).update_all(position: index+1)
    end
    
    render nothing: true
  end
end
