class Avo::Resources::PromptExecution < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :prompt, as: :belongs_to
    field :label, as: :text
    field :compiled_parameters, as: :textarea
    field :parameters_summary, as: :textarea
    field :model, as: :text
  end
end
