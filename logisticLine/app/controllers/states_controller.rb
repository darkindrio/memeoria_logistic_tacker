class StatesController < ApplicationController

  before_action :set_state, only: [:update, :destroy]

  def show
    @state = State.find(params['id'])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to stage_path(id: @state.stage_id), notice: 'Alertacambiada con exito.' }
        format.json { render :show, status: :ok, location:@state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_state
    @state = State.find(params[:state_id])
  end

  def state_params
    params.require(:state).permit(:alert)
  end



end
