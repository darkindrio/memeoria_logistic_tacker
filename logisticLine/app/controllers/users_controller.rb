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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_index_path, notice: 'Usuario actualizado con éxito' }
        format.json { render :show, status: :ok, location:@state }
      else
        format.html { render edit_user_as_admin_path(@user)}
        format.json { render json:@user.errors, status: :unprocessable_entity }
      end
    end
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
    user = User.find(params[:user_id])
    redirect_to stage_path(params[:stage_id]), notice: 'Las notificaciones del usuario '+user.email+' han sido  actualizado con éxito'
  end

  def test
    UserMailer.with(user: @user).welcome_email.deliver_now
  end

  private

  def set_line
    @user = User.find(params[:user_id])
  end
  def user_params
    params.require(:user).permit(:email, :role)
  end
end
