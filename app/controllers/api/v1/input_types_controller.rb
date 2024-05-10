# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::InputTypesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :input_type, through: :project, through_association: :input_types

    # GET /api/v1/projects/:project_id/input_types
    def index
    end

    # GET /api/v1/input_types/:id
    def show
    end

    # POST /api/v1/projects/:project_id/input_types
    def create
      if @input_type.save
        render :show, status: :created, location: [:api, :v1, @input_type]
      else
        render json: @input_type.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/input_types/:id
    def update
      if @input_type.update(input_type_params)
        render :show
      else
        render json: @input_type.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/input_types/:id
    def destroy
      @input_type.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def input_type_params
        strong_params = params.require(:input_type).permit(
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
  class Api::V1::InputTypesController
  end
end
