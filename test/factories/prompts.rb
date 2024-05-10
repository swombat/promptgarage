FactoryBot.define do
  factory :prompt do
    association :project
    name { "MyString" }
    description { "MyText" }
  end
end
