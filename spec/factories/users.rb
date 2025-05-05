FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "ComplexA#!" }
    password_confirmation { "ComplexA#!" }
   #username { "" }
    username { "user#{rand(1000)}" }
   #bio { "" }
    bio { "bio" }	 
    role { :user } #
   #role { :admin } 

end

end
