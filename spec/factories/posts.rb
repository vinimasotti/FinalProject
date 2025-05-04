FactoryBot.define do
  factory :post do
    title { 'Valid Post Title' }
    description { 'This is a valid description with more than 5 characters.' }
    user
    
  end
end
