FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "ComplexA1#!" }
    password_confirmation { "ComplexA1#!" }
    username { "" }
    bio { " " }
   #bio { "bio" }	 
    role { :user } #
   #role { :admin } 

    #after(:build) do |user|
    #user.avatar.attach(
     #   io: File.open(Rails.root.join('spec', 'fixtures', 'avatar.png')),
     #   filename: 'avatar.png',
     #   content_type: 'image/png'
    #  )
  #end
end
end
