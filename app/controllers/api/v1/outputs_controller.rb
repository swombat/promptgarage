# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::OutputsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :output, through: :prompt_execution, through_association: :outputs

    # GET /api/v1/prompt_executions/:prompt_execution_id/outputs
    def index
    end

    # GET /api/v1/outputs/:id
    def show
    end

    # POST /api/v1/prompt_executions/:prompt_execution_id/outputs
    def create
      if @output.save
        render :show, status: :created, location: [:api, :v1, @output]
      else
        render json: @output.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/outputs/:id
    def update
      if @output.update(output_params)
        render :show
      else
        render json: @output.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/outputs/:id
    def destroy
      @output.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def output_params
        strong_params = params.require(:output).permit(
          *permitted_fields,
          :label,
          :results,
          :input_tokens,
          :output_tokens,
          :message_id_api,
          :user_rating,
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
  class Api::V1::OutputsController
  end
end
