module UsersHelper
  def modify_label_color(status)
    case status
    when "finish"
      "primary"
    when "pending"
      "info"
    else
      "success"
    end

  end
end