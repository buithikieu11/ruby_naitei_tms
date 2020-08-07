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

  def is_numeric? obj
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) != nil
  end

  def get_number_value_from_param param, default_value = 0
    param.present? && is_numeric?(param) ? param : default_value
  end

  def get_string_value_from_param param, default_value = ""
    param.presence || default_value
  end

  def sort_by_column column, model_columns, default_column = "id"
    if column.present? && model_columns.include?(column.downcase)
      column.downcase
    else
      default_column
    end
  end

  def sort_by_order order, default_order = "asc"
    if order.present? && %w(asc desc).include?(order.downcase)
      order.downcase
    else
      default_order
    end
  end
end
