class Line < ApplicationRecord
    has_many :stages
    belongs_to :container
end
