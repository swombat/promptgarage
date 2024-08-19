Rails.application.routes.draw do
  # See `config/routes/*.rb` to customize these configurations.
  draw "concerns"
  draw "devise"
  draw "sidekiq"
  draw "avo"

  # `collection_actions` is automatically super scaffolded to your routes file when creating certain objects.
  # This is helpful to have around when working with shallow routes and complicated model namespacing. We don't use this
  # by default, but sometimes Super Scaffolding will generate routes that use this for `only` and `except` options.
  collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment

  # This helps mark `resources` definitions below as not actually defining the routes for a given resource, but just
  # making it possible for developers to extend definitions that are already defined by the `bullet_train` Ruby gem.
  # TODO Would love to get this out of the application routes file.
  extending = {only: []}

  scope module: "public" do
    # To keep things organized, we put non-authenticated controllers in the `Public::` namespace.
    # The root `/` path is routed to `Public::HomeController#index` by default.
  end

  namespace :webhooks do
    namespace :incoming do
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth provider webhooks above this line.
      end
    end
  end

  namespace :api do
    draw "api/v1"
    # 🚅 super scaffolding will insert new api versions above this line.
  end

  get "public/all_outputs/:prompt_id/:prompt_execution_id", to: "external#all_outputs", as: :external_all_outputs

  namespace :account do
    shallow do
      # user-level onboarding tasks.
      namespace :onboarding do
        # routes for standard onboarding steps are configured in the `bullet_train` gem, but you can add more here.
      end

      # user specific resources.
      resources :users, extending do
        namespace :oauth do
          # 🚅 super scaffolding will insert new oauth providers above this line.
        end

        # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      # team-level resources.
      resources :teams, extending do
        # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

        # add your resources here.

        resources :invitations, extending do
          # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        resources :memberships, extending do
          # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        namespace :integrations do
          # 🚅 super scaffolding will insert new integration installations above this line.
        end

        resources :invitation_keys
        resources :intelligence_credentials
        resources :projects do
          get :import_inputs, to: "projects#import_inputs"
          post "import_inputs/:input_type_id", to: "projects#import_inputs", as: :import_input
          resources :input_types
          resources :input_items
          resources :prompts do
            get "all_outputs/:prompt_execution_id", to: "outputs#all_outputs", as: :all_outputs
            resources :prompt_sections, concerns: [:sortable]
            post :execute, to: "prompt_executions#execute"
            post :fork, to: "prompts#fork"
            resources :prompt_executions do
              post :execute_again, to: "prompt_executions#execute_again"
              post :execute_all_again, to: "prompt_executions#execute_all_again"
              resources :outputs
            end
          end
        end
      end
    end
  end
end
