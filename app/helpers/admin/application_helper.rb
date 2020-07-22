module Admin::ApplicationHelper
  def is_numeric? obj
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) != nil
  end

  def get_number_value_from_param param, default_value = 0
    param.present? && is_numeric?(param) ? param : default_value
  end

  def get_string_value_from_param param, default_value = ""
    param.presence || default_value
  end
end
