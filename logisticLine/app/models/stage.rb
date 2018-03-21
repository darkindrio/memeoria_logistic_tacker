class Stage < ApplicationRecord
    belongs_to :line
    has_many :states
end
