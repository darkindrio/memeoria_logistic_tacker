class State < ApplicationRecord
  belongs_to :stage
  has_many :substates
  has_many :alert_subscribes
  
  has_many :record_states
  has_many :records, :through => :record_states, :source => :stage

  attr_accessor :current_machine

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
                    "abrobacionM" => "Aprobacion manifiesto",
                    "inspeccionCarga" => "Inscripción carga",
                    "precentacionDi" => "presentacion DI",
                    "envioSeleccion" => "Envío seleccion inspeccion termina",
                    "envioFiscalizacion" => "Envío fiscalización",
                    "envioComprovantePago" => "Envío comrobante de pago",
                    "tramitaGarantia" => "Tramitación Garantización",
                    "envioGarantia" => "Envío garantización",
                    "envioAprobacion" => "Envío aprobación gate in",
                    "envioTac" => "Envío TATC",
                    "insriSecRet" => "Incripción secuencia retiro directo",
                    "notificacionIns" => "Notificación inscripción",
                    "elaboracionCoordinacion" => "Elaboracion y publicación",
                    "coordinacion" => "Coordinación transporte"}

    return states_hash[state_name]
  end

  def get_states_idxs
    states = stage.states
    idxs = []
    states.each do |state|
        idxs << state.idx
    end
    return idxs
  end

  def get_next_state
    states = stage.states
    states.each do |state|
      if state.idx == self.idx.to_i + 1
        return state
      end
    end
  end

  def get_init_date
    initRecord = RecordState.where(stage_id: stage.id, state_id: self.id).first
    if initRecord
      return initRecord.created_at
    end
  end

  def get_end_date
    initRecord = RecordState.where(stage_id: stage.id, state_id: self.id)
    if initRecord.count == 2
      return initRecord[1].created_at
    end
  end

  def get_state_duration
    end_date = get_end_date
    if end_date
      return ((end_date-get_init_date ) / 3600).round(2)
    end
  end

  def has_next_state?()
    idxs = get_states_idxs
    self.idx != idxs.count
  end

  def get_last_state(st_machine)
    indifferent_hash = State.state_machines.with_indifferent_access
    return indifferent_hash[st_machine].states.select(&:final?).map(&:name)
  end

  def is_finish?(state_machine)
    last_state = get_last_state(state_machine)[0]
    return last_state.to_s == self.sub_state
  end



  def get_state_machine_name(stage_state_name)
    puts stage_state_name
    if stage_state_name == "Contancto Cliente- Forwarder"
      return State.state_machines[:fw].states.map &:name
    elsif stage_state_name == "Proceso de canje de B/L y envío documentos"
      return State.state_machines[:bl].states.map &:name
    elsif stage_state_name == "Presentación y envío de Manifiesto"
      return State.state_machines[:pem].states.map &:name
    elsif stage_state_name == "Garantización de CNT y liberación de TATC"
      return State.state_machines[:gr].states.map &:name
    elsif stage_state_name == "Inscripción de carga, condicion de fiscalización y pago aranceles"
      return State.state_machines[:ins].states.map &:name
    elsif stage_state_name == "Gestión e inscripción condición de retiro"
      return State.state_machines[:ret].states.map &:name
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

  state_machine :ins, initial: :inspeccionCarga do
    event :next_ins do
      transition inspeccionCarga: :precentacionDi
      transition precentacionDi: :envioSeleccion
      transition envioSeleccion: :envioFiscalizacion
      transition envioFiscalizacion: :envioComprovantePago
    end
  end

  state_machine :gr, initial: :tramitaGarantia do
    event :next_gr do
      transition tramitaGarantia: :envioGarantia
      transition envioGarantia: :envioAprobacion
      transition envioAprobacion: :envioTac
    end
  end

  state_machine :ret, initial: :insriSecRet do
    event :next_ret do
      transition insriSecRet: :notificacionIns
      transition notificacionIns: :elaboracionCoordinacion
      transition elaboracionCoordinacion: :coordinacion
    end
  end


  def next_state
    if st_machine == "fw"
      next_fw
      self.sub_state = self.fw
    elsif st_machine == "bl"
      next_bl
      self.sub_state = self.bl
    elsif st_machine == "pem"
      next_pem
      self.sub_state = self.pem
    elsif st_machine == "ins"
      next_ins
      self.sub_state = self.ins
    elsif st_machine == "gr"
      next_gr
      self.sub_state = self.gr
    elsif st_machine == "ret"
      next_ret
      self.sub_state = self.ret
    end
  end

  def get_next_states
    posible_states = nil
    if st_machine == "fw"
      posible_states = fw_transitions
    elsif st_machine == "bl"
      posible_states = bl_transitions
    elsif st_machine == "pem"
      posible_states = pem_transitions
    elsif st_machine == "ins"
      posible_states = ins_transitions
    elsif st_machine == "gr"
      posible_states = gr_transitions
    elsif st_machine == "ret"
      posible_states = ret_transitions
    end
    return posible_states
  end

  def set_st_machine
    if st_machine == "fw"
      self.fw = sub_state
    elsif st_machine == "bl"
      self.bl = sub_state
    elsif st_machine == "pem"
      self.pem = sub_state
    elsif st_machine == "ins"
      self.ins = sub_state
    elsif st_machine == "gr"
      self.gr = sub_state
    elsif st_machine == "ret"
      self.ret = sub_state
    end
  end

end
