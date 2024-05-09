FactoryBot.define do
  factory :invitation_key do
    association :team
    key { "MyString" }
  end
end
