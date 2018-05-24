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
    @test = [
        ['Mushrooms', 3],
        ['Onions', 1],
        ['Olives', 1],
        ['Zucchini', 1],
        ['Pepperoni', 2]
    ]
    @container = Container.all

  end

  def subscribeAlert

    subscribed_alerts = ""
    if params['notifications'].present?
      params['notifications'].each do |alert|
        subscribed_alerts = subscribed_alerts+alert+';'
      end
    end
    containerUser = ContainersUser.where(user_id: params[:user_id], container_id: params[:container_id]).first
    containerUser.update_attributes(alerts: subscribed_alerts)
    redirect_to line_index_path
  end

  private

  def set_line
    @user = User.find(params[:user_id])
  end
end
