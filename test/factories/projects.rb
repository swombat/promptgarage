FactoryBot.define do
  factory :project do
    association :team
    name { "MyString" }
    description { "MyText" }
  end
end
