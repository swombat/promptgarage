# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::InvitationKeysController < Api::V1::ApplicationController
    account_load_and_authorize_resource :invitation_key, through: :team, through_association: :invitation_keys

    # GET /api/v1/teams/:team_id/invitation_keys
    def index
    end

    # GET /api/v1/invitation_keys/:id
    def show
    end

    # POST /api/v1/teams/:team_id/invitation_keys
    def create
      if @invitation_key.save
        render :show, status: :created, location: [:api, :v1, @invitation_key]
      else
        render json: @invitation_key.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/invitation_keys/:id
    def update
      if @invitation_key.update(invitation_key_params)
        render :show
      else
        render json: @invitation_key.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/invitation_keys/:id
    def destroy
      @invitation_key.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def invitation_key_params
        strong_params = params.require(:invitation_key).permit(
          *permitted_fields,
          :key,
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
  class Api::V1::InvitationKeysController
  end
end
