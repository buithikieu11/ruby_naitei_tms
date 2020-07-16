module Admin::ApplicationHelper
  def is_numeric? obj
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) != nil
  end
end
