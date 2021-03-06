class Stage < ApplicationRecord
    belongs_to :line
    has_many :states
    has_many :record_states
    has_many :records, :through => :record_states, :source => :state

    def is_state_close?(state_id)
        RecordState.where(state_id: state_id, stage_id: self.id).count == 2
    end

    def is_stage_finish?
        is_finish = true
        states.each do |state|
            if !state.is_finish?(state.st_machine)
                is_finish = false
            end
        end
      return is_finish
    end
end
