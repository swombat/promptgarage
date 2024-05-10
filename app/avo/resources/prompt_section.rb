class Avo::Resources::PromptSection < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :prompt, as: :belongs_to
    field :name, as: :text
    field :description, as: :textarea
    field :contents, as: :textarea
  end
end
