FactoryBot.define do
  factory :comment do
   text { "sample" }
    association :post
  end
end
