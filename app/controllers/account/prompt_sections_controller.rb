class Account::PromptSectionsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :prompt_section, through: :prompt, through_association: :prompt_sections

  # GET /account/prompts/:prompt_id/prompt_sections
  # GET /account/prompts/:prompt_id/prompt_sections.json
  def index
    delegate_json_to_api
  end

  # GET /account/prompt_sections/:id
  # GET /account/prompt_sections/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/prompts/:prompt_id/prompt_sections/new
  def new
  end

  # GET /account/prompt_sections/:id/edit
  def edit
  end

  # POST /account/prompts/:prompt_id/prompt_sections
  # POST /account/prompts/:prompt_id/prompt_sections.json
  def create
    respond_to do |format|
      if @prompt_section.save
        format.html { redirect_to [:account, @prompt_section], notice: I18n.t("prompt_sections.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @prompt_section] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/prompt_sections/:id
  # PATCH/PUT /account/prompt_sections/:id.json
  def update
    respond_to do |format|
      if @prompt_section.update(prompt_section_params)
        format.html { redirect_to [:account, @prompt_section], notice: I18n.t("prompt_sections.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @prompt_section] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/prompt_sections/:id
  # DELETE /account/prompt_sections/:id.json
  def destroy
    @prompt_section.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @prompt, :prompt_sections], notice: I18n.t("prompt_sections.notifications.destroyed") }
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
