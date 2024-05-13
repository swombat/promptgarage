class Account::PromptsController < Account::ApplicationController
  account_load_and_authorize_resource :prompt, through: :project, through_association: :prompts

  # GET /account/projects/:project_id/prompts
  # GET /account/projects/:project_id/prompts.json
  def index
    delegate_json_to_api
  end

  # GET /account/prompts/:id
  # GET /account/prompts/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/prompts/new
  def new
  end

  # GET /account/prompts/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/prompts
  # POST /account/projects/:project_id/prompts.json
  def create
    respond_to do |format|
      if @prompt.save
        format.html { redirect_to [:account, @prompt], notice: I18n.t("prompts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @prompt] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/prompts/:id
  # PATCH/PUT /account/prompts/:id.json
  def update
    respond_to do |format|
      if @prompt.update(prompt_params)
        format.html { redirect_to [:account, @prompt], notice: I18n.t("prompts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @prompt] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/prompts/:id
  # DELETE /account/prompts/:id.json
  def destroy
    @prompt.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :prompts], notice: I18n.t("prompts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def fork
    @prompt = Prompt.find(params[:prompt_id]).fork
    redirect_to [:account, @prompt]
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
