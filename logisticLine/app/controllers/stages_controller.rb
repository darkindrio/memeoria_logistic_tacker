class StagesController < ApplicationController

  def show
    @stage = Stage.find(params['id'])
    @stage.states.each do |st|
      st.set_st_machine
    end
    authorize! :read, @stage
  end

  def upload

  end

end
