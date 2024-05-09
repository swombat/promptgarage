class Account::InvitationKeysController < Account::ApplicationController
  account_load_and_authorize_resource :invitation_key, through: :team, through_association: :invitation_keys

  # GET /account/teams/:team_id/invitation_keys
  # GET /account/teams/:team_id/invitation_keys.json
  def index
    delegate_json_to_api
  end

  # GET /account/invitation_keys/:id
  # GET /account/invitation_keys/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/invitation_keys/new
  def new
  end

  # GET /account/invitation_keys/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/invitation_keys
  # POST /account/teams/:team_id/invitation_keys.json
  def create
    respond_to do |format|
      if @invitation_key.save
        format.html { redirect_to [:account, @invitation_key], notice: I18n.t("invitation_keys.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @invitation_key] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invitation_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/invitation_keys/:id
  # PATCH/PUT /account/invitation_keys/:id.json
  def update
    respond_to do |format|
      if @invitation_key.update(invitation_key_params)
        format.html { redirect_to [:account, @invitation_key], notice: I18n.t("invitation_keys.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @invitation_key] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invitation_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/invitation_keys/:id
  # DELETE /account/invitation_keys/:id.json
  def destroy
    @invitation_key.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :invitation_keys], notice: I18n.t("invitation_keys.notifications.destroyed") }
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
