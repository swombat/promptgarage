class Account::ProjectsController < Account::ApplicationController
  account_load_and_authorize_resource :project, through: :team, through_association: :projects

  # GET /account/teams/:team_id/projects
  # GET /account/teams/:team_id/projects.json
  def index
    delegate_json_to_api
  end

  # GET /account/projects/:id
  # GET /account/projects/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/projects/new
  def new
  end

  # GET /account/projects/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/projects
  # POST /account/teams/:team_id/projects.json
  def create
    respond_to do |format|
      if @project.save
        format.html { redirect_to [:account, @project], notice: I18n.t("projects.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @project] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/projects/:id
  # PATCH/PUT /account/projects/:id.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to [:account, @project], notice: I18n.t("projects.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @project] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/projects/:id
  # DELETE /account/projects/:id.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :projects], notice: I18n.t("projects.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def import_inputs
    @project = current_team.projects.find(params[:project_id])
    @input_types = current_team.projects.reject { |project| project.id == @project.id }.collect(&:input_types).flatten

    if request.post?
      @input_type = InputType.find(params[:input_type_id])
      if current_team.projects.collect(&:input_types).flatten.collect(&:id).include?(@input_type.id)
        @new_type = @project.input_types.create(name: @input_type.name, description: @input_type.description)
        @input_type.input_items.each do |item|
          @new_type.input_items.create(name: item.name, contents: item.contents, project_id: @project.id, used: false)
        end
      end
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
