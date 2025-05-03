FactoryBot.define do
  factory :user do
    sequence(:email) { |n| " " }
    password { '123456!A' }
    password_confirmation { '123456!A' }
    username { " " }
    bio { " " }
    role { :user } # default role as per your model

   # after(:build) do |user|
    #  user.avatar.attach(
     #   io: File.open(Rails.root.join('spec', 'fixtures', 'avatar.png')),
      #  filename: 'avatar.png',
       # content_type: 'image/png'
      #)
  #end
end
end
