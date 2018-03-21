class State < ApplicationRecord
  belongs_to :stage
  has_many :substates
  
  state_machine :b_l, initial: :gestionando do

    event :envio do
      transition gestionando: :enviando
    end

  end   
 
end
