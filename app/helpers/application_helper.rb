module ApplicationHelper
  def convert_time(datetime)
    DateTime.parse(datetime.to_s).strftime("%d/%m/%Y")
  end

  def modify_status_label_color(status)
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
