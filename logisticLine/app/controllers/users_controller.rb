class UsersController < ApplicationController
  include UsersHelper
  before_action :set_line, only: [:edit, :update, :destroy, :subscribeAlert]
  def index
    @users = User.all
  end

  def edit

  end

  def show
    ids =  AlertSubscribe.where(user_id: current_user.id).map(&:container_id).uniq
    @containers = Container.find(ids)
  end

  def update

  end

  def data

  end

  def subscribeAlert
    container = Container.find(params[:container_id])
    if params['state_box'].present?
      subscribe(0, container)
    else
      if current_user.has_alert?(0, container)
        current_user.alert_subscribes.where(notification_type: 0).first.destroy
      end
    end
    if params['alert_box'].present?
      subscribe(1, container)
    else
      if current_user.has_alert?(1, container)
        current_user.alert_subscribes.where(notification_type: 1).first.destroy
      end
    end
    if params['finish_box'].present?
      subscribe(2, container)
    else
      if current_user.has_alert?(2, container)
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
