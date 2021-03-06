class ContainersController < ApplicationController

  def new
    @container = Container.new
  end

  def create
    @container = Container.new(container_params)
    line = Line.new
    line.name = "Línea Logística de importación directa manifestada"
    line.description = "Línea en la que el contenedor realiza su trámite de manera anticipada para ser manifestado a un almacén extraportuario,
      otorgando a éste la total responsabilidad sobre el contenedor, tanto antes y después de ser recepcionado en el terminal, haciéndose cargo de los
      trámites aduaneros para la internación y control de los pagos correspondientes, cumpliendo así un rol netamente administrativo.
      Dando finalmente autorización a la entrega directa del contenedor sobre el transporte terrestre del importador para ser despachado
      desde el terminal hacia su bodega y posteriormente ser devuelto al depósito de vacíos.
      Esta línea contempla 14 procesos principales que dan lugar a interacciones entre actores y documentos a través de ésta."
    line.n_actors = "10"
    line.n_stages = "3"
    line.save

    s1 = Stage.new
    s1.idx = 1
    s1.name = "Etapa maritima"
    s1.description = "Esta etapa comienza con la negociación entre el importador y el freight forwarder (FFW), momento en que se establece el
      contrato de importación y el envío de documentos propios de la mercancía a importar para que éste último pueda realizar los procesos de canje de B/L;
      estos documentos son los siguientes: nota de gastos, packing list, certificado de destinación aduanera (CDA) y seguros. Recibido estos documentos,
      el FFW comienza la gestión del B/L con la naviera, presentando una solicitud para que éste sea emitido y enviado. Con el documento el FFW
      procede a completar datos de la mercancía y flete acudiendo a las oficinas de la naviera para el canje de éste, proceso en que
      se corroboran y corrigen los datos, con fin de legalizar e informar al terminal de destino. Acto seguido, el FFW envía los
      documentos antes señalados, incluyendo el B/L canjeado al agente de aduana (AGA),
      para que éste realice la gestión del manifiesto al almacén extraportuario (AEP) y proceda a la internación de la carga."
    s1.n_actors = 9
    s1.n_process = 25

    state_fw = State.new
    state_fw.st_machine = "fw"
    state_fw.sub_state = "negociarFw"
    state_fw.name = "Contancto Cliente- Forwarder"
    state_fw.idx = 1
    record = RecordState.new

    s1.states << state_fw

    state_bl = State.new
    state_bl.st_machine = "bl"
    state_bl.sub_state = "gestionBl"
    state_bl.idx = 2
    state_bl.name = "Proceso de canje de B/L y envío documentos"
    s1.states << state_bl

    state_pem = State.new
    state_pem.st_machine = "pem"
    state_pem.name = "Presentación y envío de Manifiesto"
    state_pem.sub_state = "gestionM"
    state_pem.idx = 3
    s1.states << state_pem

    state_ins = State.new
    state_ins.st_machine = "ins"
    state_ins.name = "Inscripción de carga, condicion de fiscalización y pago aranceles"
    state_ins.sub_state = "inspeccionCarga"
    state_ins.idx = 4
    s1.states<< state_ins

    state_gr = State.new
    state_gr.st_machine = "gr"
    state_gr.name = "Garantización de CNT y liberación de TATC"
    state_gr.sub_state = "tramitaGarantia"
    state_gr.idx = 5
    s1.states << state_gr

    state_ret = State.new
    state_ret.st_machine = "ret"
    state_ret.name = "Gestión e inscripción condición de retiro"
    state_ret.sub_state = "insriSecRet"
    state_ret.idx = 6
    s1.states << state_ret

    s2 = Stage.new
    s2.description = "Esta etapa comienza con el arribo y atraque de la nave en el terminal marítimo, momento
      en que se hace recepción documental de los contenedores, emitiéndose el documento de
      papeleta de recepción, para ser enviado al AEP con el objetivo de notificar la actividad.
      Posterior al envío, el terminal portuario realiza la validación de la secuencia de retiro,
      confirmando horarios de citas para el despacho. Por otro lado, el AEP genera el documento
      de recepción del contenedor bajo la condición manifestada en la etapa anterior, plasmando
      su responsabilidad en la recepción de éste. Este documento es enviado al agente de aduana
      con la finalidad de completar la documentación necesaria para la internación de la carga.
      Acto seguido, el agente de aduana acude al AEP, realizando la presentación de documentos
      para que ésta sea chequeada y llevada a la Aduana a ser visada; presentando los
      documentos de declaración de ingreso, TATC, pago de los derechos, selección de
      inspección o fiscalización, papeleta de recepción de AEP y la guía de despacho. Luego de
      realizada la internación, el AEP devuelve la documentación aprobada al agente de aduana
      para concluir con el pago de los servicios y confirmar el transporte para el retiro y despacho
      del contenedor ya internado. Paralelamente a este proceso se realiza la aprobación, descarga
      y acopio de los contenedores dentro del terminal basados en la secuencia de retiro
      publicada."
    s2.name = "Etapa aduana"
    s2.n_actors = 4
    s2.n_process = 13
    s2.idx = 2

    state_ter_1= State.new
    state_ter_1.st_machine = "ter1"
    state_ter_1.name = "Procesamiento CNT y validación de secuencia retiro"
    state_ter_1.sub_state = "ad10"
    state_ter_1.idx = 1
    record2 = RecordState.new
    s2.states << state_ter_1

    state_ter_2 = State.new
    state_ter_2.st_machine = "ter2"
    state_ter_2.name = "Proceso Visación de CNT"
    state_ter_2.sub_state = "ad20"
    state_ter_2.idx = 2
    s2.states << state_ter_2

    state_ter_3 = State.new
    state_ter_3.st_machine = "ter3"
    state_ter_3.name = "Descarga, traslado y acopio de CNT según secuencia de despacho"
    state_ter_3.sub_state = "ad30"
    state_ter_3.idx = 3
    s2.states << state_ter_3

    s3 = Stage.new
    s3.description = "Esta etapa comienza con la coordinación entre el agente de aduana y el transportista,
      enviándose a este último los documentos de guía de despacho y papeleta de recepción.
      Luego el agente de aduana notifica al almacén extraportuario el despacho a realizarse.
      Posteriormente el almacén habiendo confirmado con el terminal el retiro, hace envío físico
      del tarjetón al transportista en el antepuerto, documento que especifica la aprobación por
      parte del almacén extraportuario, quien había asumido la responsabilidad mediante el
      manifiesto, para poder ser retirado normalmente del terminal. Una vez recibido el tarjetón,
      76dentro del horario estipulado de la cita, el transporte se dirige al ingreso del terminal donde
      la documentación es chequeada y se procede al registro y aprobación del ingreso para ser
      cargado. Terminado esto, se emite la solicitud de salida, presentando los documentos de
      declaración de ingreso, TATC y papeleta de recepción, siendo adjuntado entre ellos el
      interchange emitido por el terminal. Este documento indica la fecha y estado físico en que
      se despachó el contenedor, señalando posibles daños observados al momento de ser
      descargado. Una vez retirado el contenedor, el transportista se dirige a la bodega del
      importador para realizar la desconsolidación. Paralelamente, se lleva a cabo la coordinación
      de transporte entre el agente de aduana y el trasportista, enviándose al transportista el
      comprobante de Gate In para hacer entrega del contenedor vacío en el depósito asignado.
      Habiendo terminado el desconsolidado, el contenedor es llevado al depósito, donde es
      chequeado documentalmente concluyendo la etapa con el cierre del TATC."
    s3.name = "Etapa terrestre"
    s3.n_process = 17
    s3.n_actors = 6
    s3.idx = 3

    ter1 = State.new
    ter1.name = "Coordinación transporte y retiro según horario"
    ter1.st_machine = "ter4"
    ter1.idx = 1
    ter1.sub_state = "ter00"
    s3.states << ter1

    ter2 = State.new
    ter2.name = "Procesamiento de ingreso de transporte, recibo de tarjetón"
    ter2.st_machine = "ter5"
    ter2.idx = 2
    ter2.sub_state = "ter10"
    s3.states << ter2

    ter3 = State.new
    ter3.name = "Ingreso camión y carga de CNT"
    ter3.st_machine = "ter6"
    ter3.idx = 3
    ter3.sub_state = "ter20"
    s3.states << ter3

    ter4 = State.new
    ter4.name = "Salida terminal y despacho a bodega de cliente"
    ter4.st_machine = "ter7"
    ter4.idx = 4
    ter4.sub_state = "ter30"
    s3.states << ter4

    ter5 = State.new
    ter5.name = "Desconsolidación CNT y devolución a depósito de vacíos"
    ter5.st_machine = "ter8"
    ter5.idx = 5
    ter5.sub_state = "ter40"
    s3.states << ter5

    line.stages << s1
    line.stages << s2
    line.stages << s3

    line.stages.each do |stage|
      stage.states.each do |state|
        state.alert = "normal"
      end
    end

    @container.line = line
    @container.users << current_user


    respond_to do |format|
      if @container.save
        record.state = state_fw
        record.stage = s1
        record.save


        format.html { redirect_to line_index_path, notice: 'Container was successfully created.' }
        format.json { render :show, status: :created, location: @container }
      else
        format.html { render :new }
        format.json { render json: line_index_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def AddUser
    container = Container.find(params['container_id'])
    user = User.find(params['users']['user_id'])
    container.users << user
    container.save
    redirect_to stage_path(params['stage_id']) ,notice: 'Se ha agregado el usuario '+ user.email
  end

  def plot
    @test = [
        ['Mushrooms', 3.8],
        ['Onions', 1.7],
        ['Olives', 1],
        ['Zucchini', 1],
        ['Pepperoni', 2]

    ]

    @h_data = []
    @container = Container.find(params[:container_id])
    @container.line.stages.each do |stage|
      h_stage_data = []
      stage.states.each do |state|
        h_state_data = []
        duration_sum = 0
        duration_count = 0
        h_f_states = []
        h_states = State.where(name: state.name)
        h_states.each do |state|
          if state.record_states.count == 2
            duration = ((state.record_states[1].created_at - state.record_states[0].created_at)/3600).round(2)
            duration_sum = duration_sum + duration
            duration_count += 1
          end
        end
        if duration_count != 0
          h_prom = (duration_sum / duration_count).round(2)
          h_state_data << state.name
          h_state_data << h_prom
        else
          h_state_data << state.name
          h_state_data << 1
        end
        h_stage_data << h_state_data
      end
      @h_data << h_stage_data
    end

    @container = Container.find(params[:container_id])
    @data = []
    states_names = []
    states_names << 'Genre'
    stages_duration = []
    st_counter = 0
    @container.line.stages.each do |stage|
      stage_data = []
      aux_stage_duration = []
      stage.states.each do |state|
        state_data = []
        state_data << state.name
        states_names << state.name
        records =  RecordState.where(state_id: state.id)
        if records and records.count > 1
          duration = ((records[1].created_at - records[0].created_at)/3600).round(2)
          state_data << duration
          aux_stage_duration << duration
        else
          state_data << 1
          aux_stage_duration << 1
        end
        stage_data << state_data
      end
      @data << stage_data
      @data << @h_data[st_counter]
      st_counter +=1
      stages_duration << aux_stage_duration
    end



    puts "//////////////////"
    puts @h_data








    array_vero_1 = Array.new(stages_duration[0].count , 0)
    array_vero_2 = Array.new(stages_duration[1].count , 0)
    array_vero_3 = Array.new(stages_duration[2].count , 0)

    arr_1 = stages_duration[0] + array_vero_2 + array_vero_3
    arr_1.unshift('Etapa maritima')
    arr_1 << ''
    arr_2 = array_vero_1 + stages_duration[1] + array_vero_3
    arr_2.unshift('Etapa aduana')
    arr_2 << ''
    arr_3 = array_vero_1 + array_vero_2 + stages_duration[2]
    arr_3.unshift('Etapa terrestre')
    arr_3 << ''

    @summary_data = []
    @summary_data << states_names
    @summary_data << arr_1
    @summary_data << arr_2
    @summary_data << arr_3


    @alerts = []
    @total_alerts = []
    header = ['Aletas', 'Peligro', 'Precaucion', 'Normal', 'Avg']

    all_alerts = AlertSubscribe.all
    n_total_alerts = all_alerts.count
    n_total_warnings = all_alerts.select{|o| o.notification_type == "warning"}.count
    n_total_danger = all_alerts.select{|o| o.notification_type == "danger"}.count
    n_total_normal = all_alerts.select{|o| o.notification_type == "normal"}.count

    @container.line.stages.each do |stage|
      stage_alerts = []
      stage_alerts << header
      stage.states.each do |state|
        alert_data = []
        alert_data << state.name
        state_alerts = AlertSubscribe.where(state_id: state.id)
        total_state_alert = AlertSubscribe.joins(:state).where('states.name' => state.name).group(:id).length
        if state_alerts.count > 0
          puts state.name
          puts state.id
          n_danger = state_alerts.select{|o| o.notification_type == "danger"}.count
          n_warning = state_alerts.select{|o| o.notification_type == "warning"}.count
          n_normal = state_alerts.select{|o| o.notification_type == "normal"}.count
          alert_data << n_danger
          alert_data << n_normal
          alert_data << n_warning

          alert_data << state_alerts.count / total_state_alert
        else
          alert_data = alert_data + Array.new(3 , 0)
          alert_data << 0
        end
        stage_alerts << alert_data
      end
      @total_alerts << stage_alerts
    end











  end

  def RemoveUser
    container = Container.find(params['container_id'])
    user = User.find(params['users_delete']['user_id'])
    users = []
    container.users.each do |u|
      if u.id.to_i != params['users_delete']['user_id'].to_i
        users << u
      end
    end
    container.users = users
    container.save
    redirect_to stage_path(params['stage_id']),notice: 'Se ha eliminado el usuario '+ user.email
  end

  def data

  end

  def alert
    @stage = Stage.find(params[:stage_id])
    @alerts = AlertSubscribe.where(container_id: @stage.line.container.id )
  end

  private

  def container_params
    params.require(:container).permit(:number, :eta, :travel_number, :storer, :consignee, :codename)
  end

end
