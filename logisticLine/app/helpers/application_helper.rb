
module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "alert"
        "alert-warning"
      when "alert-block"
        "alert-block"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

end