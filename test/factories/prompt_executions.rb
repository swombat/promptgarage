FactoryBot.define do
  factory :prompt_execution do
    association :prompt
    label { "MyString" }
    compiled_parameters { "MyText" }
    parameters_summary { "MyText" }
    model { "MyString" }
  end
end
