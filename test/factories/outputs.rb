FactoryBot.define do
  factory :output do
    association :prompt_execution
    label { "MyString" }
    results { "MyText" }
    input_tokens { 1 }
    output_tokens { 1 }
    message_id_api { "MyString" }
    user_rating { 1 }
  end
end
