class StatesController < ApplicationController

  before_action :set_state, only: [:update, :destroy, :next_state, :change_duration]

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

    if @state.is_finish?(@state.st_machine)
      stage = @state.stage
      stage.records << @state

      if @state.has_next_state? and @state.is_finish?(@state.st_machine)
        nextState = @state.get_next_state
        stage.records << nextState
      end
      stage.save
    end
    stage = @state.stage
    if stage.is_stage_finish?
      line = stage.line
      if stage.idx < line.stages.count
        RecordState.create(stage: line.stages[stage.idx], state:  line.stages[stage.idx].states[0])
      end
    end
    redirect_to stage_path(id: @state.stage_id), notice: 'Se ha cambiado el estado.'
  end

  def change_duration
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to stage_path(id: @state.stage_id), notice: 'Estado actualizado con éxito' }
        format.json { render :show, status: :ok, location:@state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @state.update(state_params)
        UserMailer.welcome_email.deliver_now
        AlertSubscribe.create(user: current_user,
                              container:@state.stage.line.container,
                              notification_type: params['state']['alert'],
                              message: params['alert_message'],
                              state: @state)
        format.html { redirect_to stage_path(id: @state.stage_id), notice: 'Alerta cambiada con éxito, registro guardado con éxito.' }
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
    params.require(:state).permit(:alert, :duration)
  end



end
