class Avo::Resources::Output < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :prompt_execution, as: :belongs_to
    field :label, as: :text
    field :results, as: :textarea
    field :input_tokens, as: :number
    field :output_tokens, as: :number
    field :message_id_api, as: :text
    field :user_rating, as: :number
  end
end
