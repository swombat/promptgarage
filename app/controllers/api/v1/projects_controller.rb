# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ProjectsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :project, through: :team, through_association: :projects

    # GET /api/v1/teams/:team_id/projects
    def index
    end

    # GET /api/v1/projects/:id
    def show
    end

    # POST /api/v1/teams/:team_id/projects
    def create
      if @project.save
        render :show, status: :created, location: [:api, :v1, @project]
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/projects/:id
    def update
      if @project.update(project_params)
        render :show
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/projects/:id
    def destroy
      @project.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def project_params
        strong_params = params.require(:project).permit(
          *permitted_fields,
          :name,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::ProjectsController
  end
end
