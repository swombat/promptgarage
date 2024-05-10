class Account::InputItemsController < Account::ApplicationController
  account_load_and_authorize_resource :input_item, through: :project, through_association: :input_items

  # GET /account/projects/:project_id/input_items
  # GET /account/projects/:project_id/input_items.json
  def index
    delegate_json_to_api
  end

  # GET /account/input_items/:id
  # GET /account/input_items/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/input_items/new
  def new
  end

  # GET /account/input_items/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/input_items
  # POST /account/projects/:project_id/input_items.json
  def create
    respond_to do |format|
      if @input_item.save
        format.html { redirect_to [:account, @input_item], notice: I18n.t("input_items.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @input_item] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @input_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/input_items/:id
  # PATCH/PUT /account/input_items/:id.json
  def update
    respond_to do |format|
      if @input_item.update(input_item_params)
        format.html { redirect_to [:account, @input_item], notice: I18n.t("input_items.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @input_item] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @input_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/input_items/:id
  # DELETE /account/input_items/:id.json
  def destroy
    @input_item.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :input_items], notice: I18n.t("input_items.notifications.destroyed") }
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
