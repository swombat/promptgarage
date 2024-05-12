class Account::PromptExecutionsController < Account::ApplicationController
  account_load_and_authorize_resource :prompt_execution, through: :prompt, through_association: :prompt_executions

  # GET /account/prompts/:prompt_id/prompt_executions
  # GET /account/prompts/:prompt_id/prompt_executions.json
  def index
    delegate_json_to_api
  end

  # GET /account/prompt_executions/:id
  # GET /account/prompt_executions/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/prompts/:prompt_id/prompt_executions/new
  def new
    @form = PromptExecutionForm.new(prompt: @prompt)
  end

  # GET /account/prompt_executions/:id/edit
  def edit
  end

  def execute
    @prompt = Prompt.find(params[:prompt_id])
    @form = PromptExecutionForm.new(prompt: @prompt)
    @form.assign_attributes(params.require(:prompt_execution_form).permit([:label, :model] + @prompt.arguments.collect { |arg| {arg.underscore.to_sym => [] } } ))

    Rails.logger.debug "=============== #{@form.inspect}"

    @form.all_objects.each do |object|
      authorize! :edit, object
    end

    # TODO : create prompt execution and execute it!
  end

  # POST /account/prompts/:prompt_id/prompt_executions
  # POST /account/prompts/:prompt_id/prompt_executions.json
  def create
    respond_to do |format|
      if @prompt_execution.save
        format.html { redirect_to [:account, @prompt_execution], notice: I18n.t("prompt_executions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @prompt_execution] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/prompt_executions/:id
  # PATCH/PUT /account/prompt_executions/:id.json
  def update
    respond_to do |format|
      if @prompt_execution.update(prompt_execution_params)
        format.html { redirect_to [:account, @prompt_execution], notice: I18n.t("prompt_executions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @prompt_execution] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/prompt_executions/:id
  # DELETE /account/prompt_executions/:id.json
  def destroy
    @prompt_execution.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @prompt, :prompt_executions], notice: I18n.t("prompt_executions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
