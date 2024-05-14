class Account::OutputsController < Account::ApplicationController
  account_load_and_authorize_resource :output, through: :prompt_execution, through_association: :outputs

  # GET /account/prompt_executions/:prompt_execution_id/outputs
  # GET /account/prompt_executions/:prompt_execution_id/outputs.json
  def index
    delegate_json_to_api
  end

  # GET /account/outputs/:id
  # GET /account/outputs/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/prompt_executions/:prompt_execution_id/outputs/new
  def new
  end

  # GET /account/outputs/:id/edit
  def edit
  end

  # POST /account/prompt_executions/:prompt_execution_id/outputs
  # POST /account/prompt_executions/:prompt_execution_id/outputs.json
  def create
    respond_to do |format|
      if @output.save
        format.html { redirect_to [:account, @output], notice: I18n.t("outputs.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @output] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @output.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/outputs/:id
  # PATCH/PUT /account/outputs/:id.json
  def update
    respond_to do |format|
      if @output.update(output_params)
        format.html { redirect_to [:account, @output], notice: I18n.t("outputs.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @output] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @output.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/outputs/:id
  # DELETE /account/outputs/:id.json
  def destroy
    @output.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @prompt_execution, :outputs], notice: I18n.t("outputs.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def all_outputs
    Rails.logger.debug("-------------------")
    @prompt = Prompt.find(params[:prompt_id])
    @execution = @prompt.prompt_executions.find(params[:prompt_execution_id])
    @executions = @prompt.prompt_executions.where(label: @execution.label)
    @outputs = @executions.collect(&:outputs).flatten
    debug(@outputs)
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
