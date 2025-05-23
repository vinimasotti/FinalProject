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

   #testing avatar
   after(:build) do |user|
    user.avatar.attach(
      io: File.open(Rails.root.join('spec', 'files', 'avatar.png')),
      filename: 'avatar.png',
      content_type: 'image/png'
    )
  end

end

end
