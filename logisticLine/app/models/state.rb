class State < ApplicationRecord
  belongs_to :stage
  has_many :substates

  def state_s(state_name)
    states_hash = { "gestionBl" => "Gestion documento B/L",
                    "envioBl" => "Envio documento B/L",
                    "canjeBl" => "Canjear documento B/l",
                    "blCanjeado" =>"Documento B/L canjeado",
                    "envioDocumento" => "Envio documento",
                    "negociarFw" => "Gestión y envío contrato",
                    "terminoFw" => "Fin gestión y envío contrato",
                    "gestionM" => "Gestion mandamiento",
                    "precentacionM" => "Precentacion mandamiento",
                    "manifestado"=> "Manifiesto manifestado",
                    "abrobacionM" => "Aprobacion manifiesto"}

    return states_hash[state_name]
  end



  def get_state_machine_name(stage_state_name)
    puts stage_state_name
    if stage_state_name == "Contancto Cliente- Forwarder"
      return State.state_machines[:fw].states.map &:name
    elsif stage_state_name == "Proceso de canje de B/L y envío documentos"
      return State.state_machines[:bl].states.map &:name
    elsif stage_state_name == "Presentación y envío de Manifiesto"
      return State.state_machines[:pem].states.map &:name
    else
      return State.state_machines[:bl].states.map &:name
    end


  end

  state_machine :bl, initial: :gestionBl do

    event :next_bl do
      transition gestionBl: :envioBl
      transition envioBl: :canjeBl
      transition canjeBl: :blCanjeado
      transition blCanjeado: :envioDocumento

    end

    event :start_gestion_bl do
      transition start: :gestionBl
    end

    event :start_fw do
      transition start: :negociarFw
    end

    event :start_gm do
      transition start: :gestionM
    end


    state :gestionBl do
      def speed
        0
      end
    end

  end

  state_machine :fw, initial: :negociarFw do
    event :next_fw do
      transition negociarFw: :terminoFw
    end
  end

  state_machine :pem, initial: :gestionM do
    event :next_pem do
      transition gestionM: :precentacionM
      transition precentacionM: :manifestado
      transition manifestado: :abrobacionM
    end
  end

  def next_state
    if name == "fw"
      next_fw
    elsif name == "bl"
      next_bl
      self.sub_state = "gestionBl"
    end
  end

  def set_state_machine
    if name == "Contancto Cliente- Forwarder"
      start_fw
      self.sub_state = "negociarFw"
    elsif name == "Proceso de canje de B/L y envío documentos"
      start_gestion_bl
      self.sub_state = "gestionBl"
    end
  end


end
