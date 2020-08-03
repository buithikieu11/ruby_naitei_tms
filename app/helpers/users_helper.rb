module UsersHelper
  def modify_label_color(status)
    case status
    when "finished"
      "primary"
    when "pending"
      "info"
    else
      "success"
    end
  end
end