# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PromptsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :prompt, through: :project, through_association: :prompts

    # GET /api/v1/projects/:project_id/prompts
    def index
    end

    # GET /api/v1/prompts/:id
    def show
    end

    # POST /api/v1/projects/:project_id/prompts
    def create
      if @prompt.save
        render :show, status: :created, location: [:api, :v1, @prompt]
      else
        render json: @prompt.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/prompts/:id
    def update
      if @prompt.update(prompt_params)
        render :show
      else
        render json: @prompt.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/prompts/:id
    def destroy
      @prompt.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def prompt_params
        strong_params = params.require(:prompt).permit(
          *permitted_fields,
          :name,
          :description,
          :parent_id,
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
  class Api::V1::PromptsController
  end
end
