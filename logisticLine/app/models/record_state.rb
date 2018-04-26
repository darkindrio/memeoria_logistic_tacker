class RecordState < ApplicationRecord
  belongs_to :state
  belongs_to :stage
end
