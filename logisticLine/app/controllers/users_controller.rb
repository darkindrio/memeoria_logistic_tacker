class UsersController < ApplicationController
  include UsersHelper
  before_action :set_line, only: [:edit, :update, :destroy, :subscribeAlert]
  def index
    @users = User.all
  end

  def edit

  end

  def update

  end

  def subscribeAlert
    if params['state_box'].present?
      subscribe(0)
    else
      if current_user.has_alert?(0)
        current_user.alert_subscribes.where(notification_type: 0).first.destroy
      end
    end
    if params['alert_box'].present?
      subscribe(1)
    else
      if current_user.has_alert?(1)
        current_user.alert_subscribes.where(notification_type: 1).first.destroy
      end
    end
    if params['finish_box'].present?
      subscribe(2)
    else
      if current_user.has_alert?(2)
        current_user.alert_subscribes.where(notification_type: 2).first.destroy
      end
    end
    redirect_to line_index_path
  end

  private

  def set_line
    @user = User.find(params[:user_id])
  end
end
