class Account::IntelligenceCredentialsController < Account::ApplicationController
  account_load_and_authorize_resource :intelligence_credential, through: :team, through_association: :intelligence_credentials

  # GET /account/teams/:team_id/intelligence_credentials
  # GET /account/teams/:team_id/intelligence_credentials.json
  def index
    delegate_json_to_api
  end

  # GET /account/intelligence_credentials/:id
  # GET /account/intelligence_credentials/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/intelligence_credentials/new
  def new
  end

  # GET /account/intelligence_credentials/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/intelligence_credentials
  # POST /account/teams/:team_id/intelligence_credentials.json
  def create
    respond_to do |format|
      if @intelligence_credential.save
        format.html { redirect_to [:account, @intelligence_credential], notice: I18n.t("intelligence_credentials.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @intelligence_credential] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @intelligence_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/intelligence_credentials/:id
  # PATCH/PUT /account/intelligence_credentials/:id.json
  def update
    respond_to do |format|
      if @intelligence_credential.update(intelligence_credential_params)
        format.html { redirect_to [:account, @intelligence_credential], notice: I18n.t("intelligence_credentials.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @intelligence_credential] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @intelligence_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/intelligence_credentials/:id
  # DELETE /account/intelligence_credentials/:id.json
  def destroy
    @intelligence_credential.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :intelligence_credentials], notice: I18n.t("intelligence_credentials.notifications.destroyed") }
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
