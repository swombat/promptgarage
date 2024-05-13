# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PromptSectionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :prompt_section, through: :prompt, through_association: :prompt_sections

    # GET /api/v1/prompts/:prompt_id/prompt_sections
    def index
    end

    # GET /api/v1/prompt_sections/:id
    def show
    end

    # POST /api/v1/prompts/:prompt_id/prompt_sections
    def create
      if @prompt_section.save
        render :show, status: :created, location: [:api, :v1, @prompt_section]
      else
        render json: @prompt_section.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/prompt_sections/:id
    def update
      if @prompt_section.update(prompt_section_params)
        render :show
      else
        render json: @prompt_section.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/prompt_sections/:id
    def destroy
      @prompt_section.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def prompt_section_params
        strong_params = params.require(:prompt_section).permit(
          *permitted_fields,
          :name,
          :description,
          :contents,
          :system_prompt,
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
  class Api::V1::PromptSectionsController
  end
end
