class Container < ApplicationRecord
  has_many :alert_subscribes
  has_many :users, :through => :alert_subscribes
  has_one  :line
end
