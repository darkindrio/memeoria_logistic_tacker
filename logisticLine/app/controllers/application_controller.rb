class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do | exception |
    redirect_to line_index_path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    if current_user.is? :statistic
      line_data_path
    else
      root_path
    end
  end
end
