class StatesController < ApplicationController

  before_action :set_state, only: [:update, :destroy, :next_state]

  def show
    @state = State.find(params['id'])
    authorize! :update, @state
  end

  def edit
  end

  def next_state
    @state.set_st_machine()
    @state.next_state
    @state.save
    redirect_to stage_path(id: @state.stage_id), notice: 'Se ha cambiado el estado.'
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
