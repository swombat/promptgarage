class Account::InputTypesController < Account::ApplicationController
  account_load_and_authorize_resource :input_type, through: :project, through_association: :input_types

  # GET /account/projects/:project_id/input_types
  # GET /account/projects/:project_id/input_types.json
  def index
    delegate_json_to_api
  end

  # GET /account/input_types/:id
  # GET /account/input_types/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/input_types/new
  def new
  end

  # GET /account/input_types/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/input_types
  # POST /account/projects/:project_id/input_types.json
  def create
    respond_to do |format|
      if @input_type.save
        format.html { redirect_to [:account, @input_type], notice: I18n.t("input_types.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @input_type] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @input_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/input_types/:id
  # PATCH/PUT /account/input_types/:id.json
  def update
    respond_to do |format|
      if @input_type.update(input_type_params)
        format.html { redirect_to [:account, @input_type], notice: I18n.t("input_types.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @input_type] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @input_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/input_types/:id
  # DELETE /account/input_types/:id.json
  def destroy
    @input_type.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :input_types], notice: I18n.t("input_types.notifications.destroyed") }
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
