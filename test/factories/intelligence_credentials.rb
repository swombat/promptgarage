FactoryBot.define do
  factory :intelligence_credential do
    association :team
    api_key { "MyString" }
    class_name { "MyString" }
  end
end
