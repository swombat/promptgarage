class Avo::Resources::IntelligenceCredential < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :api_key, as: :text
    field :class_name, as: :text
  end
end
