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
    s1.name = "Etapa maritima"
    s1.description = "Esta etapa comienza con la negociación entre el importador y el freight forwarder (FFW), momento en que se establece el
      contrato de importación y el envío de documentos propios de la mercancía a importar para que éste último pueda realizar los procesos de canje de B/L;
      estos documentos son los siguientes: nota de gastos, packing list, certificado de destinación aduanera (CDA) y seguros. Recibido estos documentos,
      el FFW comienza la gestión del B/L con la naviera, presentando una solicitud para que éste sea emitido y enviado. Con el documento el FFW
      procede a completar datos de la mercancía y flete acudiendo a las oficinas de la naviera para el canje de éste, proceso en que
      se corroboran y corrigen los datos, con fin de legalizar e informar al terminal de destino. Acto seguido, el FFW envía los
      documentos antes señalados, incluyendo el B/L canjeado al agente de aduana (AGA),
      para que éste realice la gestión del manifiesto al almacén extraportuario (AEP) y proceda a la internación de la carga."

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
    s2.name = "Etapa aduana"
    s3 = Stage.new
    s3.name = "Etapa terrestre"
    line.stages << s1
    line.stages << s2
    line.stages << s3

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

  def RemoveUser
    container = Container.find(params['container_id'])
    user = User.find(params['users']['user_id'])
    users = []
    container.users.each do |u|
      if u.id.to_i != params['users']['user_id'].to_i
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
