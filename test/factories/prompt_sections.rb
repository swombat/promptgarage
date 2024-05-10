FactoryBot.define do
  factory :prompt_section do
    association :prompt
    name { "MyString" }
    description { "MyText" }
    contents { "MyText" }
  end
end
