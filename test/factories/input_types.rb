FactoryBot.define do
  factory :input_type do
    association :project
    name { "MyString" }
    description { "MyText" }
  end
end
