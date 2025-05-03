FactoryBot.define do
  factory :comment do
    text { "Sample comment" }
    association :post
  end
end
