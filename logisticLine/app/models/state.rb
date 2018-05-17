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
                    "coordinacion" => "Coordinación transporte",
                    "ad10" => "Recepción contenedor",
                    "ad11" => "Notificación recepción termina",
                    "ad12" => "Validación secuencia",
                    "ad13" => "Aprobación CNT directos",
                    "ad14" => "Descarga Contenedores",
                    "ad20" => "Emisión papeleta AEP",
                    "ad21" => "Envío papeleta AEP",
                    "ad30" => "Presenta documentación",
                    "ad31" => "Chequeo documental",
                    "ad32" => "Visación Documenta",
                    "ad33" => "Visado",
                    "ad34" => "Facturación servicios",
                    "ter00" => "Coordinación y envío",
                    "ter01" => "Confirmación",
                    "ter10" => "Notificación despacho",
                    "ter11" => "Confirmación retiro",
                    "ter12" => "Envío tarjetón",
                    "ter20" => "Ingreso terminal y chequeo",
                    "ter21" => "Registro Ingreso",
                    "ter22" => "Ingreso Aprobado",
                    "ter23" => "Carga contenedor",
                    "ter30" => "Solicitud salida terminal",
                    "ter31" => "Salida terminal ok",
                    "ter40" => "Desconsolidado",
                    "ter41" => "Devolve",
                    "ter42" => "Ingreso depósito y Chequeo",
                    "ter43" => "cierre de TATC"}

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

  def is_prev_state_finish?
    states = self.stage.states
    if self.idx != 1
      prevState = states[self.idx.to_i - 2]
      last_state = get_last_state(prevState.st_machine)[0]
      return last_state.to_s == prevState.sub_state
    else
      return true
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
    if stage_state_name == "fw"
      return State.state_machines[:fw].states.map &:name
    elsif stage_state_name == "bl"
      return State.state_machines[:bl].states.map &:name
    elsif stage_state_name == "pem"
      return State.state_machines[:pem].states.map &:name
    elsif stage_state_name == "gr"
      return State.state_machines[:gr].states.map &:name
    elsif stage_state_name == "ins"
      return State.state_machines[:ins].states.map &:name
    elsif stage_state_name == "ret"
      return State.state_machines[:ret].states.map &:name
    elsif stage_state_name == "ter1"
      return State.state_machines[:ter1].states.map &:name
    elsif stage_state_name == "ter2"
      return State.state_machines[:ter2].states.map &:name
    elsif stage_state_name == "ter3"
      return State.state_machines[:ter3].states.map &:name
    elsif stage_state_name == "ter4"
      return State.state_machines[:ter4].states.map &:name
    elsif stage_state_name == "ter5"
      return State.state_machines[:ter5].states.map &:name
    elsif stage_state_name == "ter3"
      return State.state_machines[:ter3].states.map &:name
    elsif stage_state_name == "ter6"
      return State.state_machines[:ter6].states.map &:name
    elsif stage_state_name == "ter7"
      return State.state_machines[:ter7].states.map &:name
    elsif stage_state_name == "ter8"
      return State.state_machines[:ter8].states.map &:name
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

  state_machine :ter1, initial: :ad10 do
    event :next_ter1 do
      transition ad10: :ad11
      transition ad11: :ad12
      transition ad12: :ad13
      transition ad13: :ad14
    end
  end

  state_machine :ter3, initial: :ad30 do
    event :next_ter3 do
      transition ad30: :ad31
      transition ad31: :ad32
      transition ad32: :ad33
      transition ad33: :ad34
    end
  end

  state_machine :ter2, initial: :ad20 do
    event :next_ter2 do
      transition ad20: :ad21
    end
  end

  state_machine :ter4, initial: :ter00 do
    event :next_ter4 do
      transition ter00: :ter01
    end
  end

  state_machine :ter5, initial: :ter10 do
    event :next_ter5 do
      transition ter10: :ter11
      transition ter11: :ter12
    end
  end

  state_machine :ter6, initial: :ter20 do
    event :next_ter6 do
      transition ter20: :ter21
      transition ter21: :ter22
      transition ter22: :ter23
      transition ter23: :ter24
    end
  end

  state_machine :ter7, initial: :ter30 do
    event :next_ter7 do
      transition ter30: :ter31
    end
  end

  state_machine :ter8, initial: :ter40 do
    event :next_ter8 do
      transition ter40: :ter41
      transition ter41: :ter42
      transition ter42: :ter43
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
    elsif st_machine == "ter1"
      next_ter1
      self.sub_state = self.ter1
    elsif st_machine == "ter2"
      next_ter2
      self.sub_state = self.ter2
    elsif st_machine == "ter3"
      next_ter3
      self.sub_state = self.ter3
    elsif st_machine == "ter3"
      next_ter3
      self.sub_state = self.ter3
    elsif st_machine == "ter4"
      next_ter4
      self.sub_state = self.ter4
    elsif st_machine == "ter5"
      next_ter5
      self.sub_state = self.ter5
    elsif st_machine == "ter6"
      next_ter6
      self.sub_state = self.ter6
    elsif st_machine == "ter7"
      next_ter7
      self.sub_state = self.ter7
    elsif st_machine == "ter8"
      next_ter8
      self.sub_state = self.ter8
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
    elsif st_machine == "ter1"
      posible_states = ter1_transitions
    elsif st_machine == "ter2"
      posible_states = ter2_transitions
    elsif st_machine == "ter3"
      posible_states = ter3_transitions
    elsif st_machine == "ter4"
      posible_states = ter4_transitions
    elsif st_machine == "ter5"
      posible_states = ter5_transitions
    elsif st_machine == "ter6"
      posible_states = ter6_transitions
    elsif st_machine == "ter7"
      posible_states = ter7_transitions
    elsif st_machine == "ter8"
      posible_states = ter8_transitions
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
    elsif st_machine == "ter1"
      self.ter1 = sub_state
    elsif st_machine == "ter2"
      self.ter2 = sub_state
    elsif st_machine == "ter3"
      self.ter3 = sub_state
    elsif st_machine == "ter4"
      self.ter4 = sub_state
    elsif st_machine == "ter5"
      self.ter5 = sub_state
    elsif st_machine == "ter6"
      self.ter6 = sub_state
    elsif st_machine == "ter7"
      self.ter7 = sub_state
    elsif st_machine == "ter8"
      self.ter8 = sub_state
    end
  end

end
