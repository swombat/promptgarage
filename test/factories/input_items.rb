FactoryBot.define do
  factory :input_item do
    association :project
    name { "MyString" }
    type { nil }
    contents { "MyText" }
  end
end
