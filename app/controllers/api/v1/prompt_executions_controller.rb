# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PromptExecutionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :prompt_execution, through: :prompt, through_association: :prompt_executions

    # GET /api/v1/prompts/:prompt_id/prompt_executions
    def index
    end

    # GET /api/v1/prompt_executions/:id
    def show
    end

    # POST /api/v1/prompts/:prompt_id/prompt_executions
    def create
      if @prompt_execution.save
        render :show, status: :created, location: [:api, :v1, @prompt_execution]
      else
        render json: @prompt_execution.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/prompt_executions/:id
    def update
      if @prompt_execution.update(prompt_execution_params)
        render :show
      else
        render json: @prompt_execution.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/prompt_executions/:id
    def destroy
      @prompt_execution.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def prompt_execution_params
        strong_params = params.require(:prompt_execution).permit(
          *permitted_fields,
          :label,
          :compiled_parameters,
          :parameters_summary,
          :model,
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
  class Api::V1::PromptExecutionsController
  end
end
