FactoryBot.define do
  factory :post do
    title { 'Valid Post Title' }
    description { 'This is a valid description with more than 5 characters.' }
    association :user

    after(:build) do |post|
      post.images.attach([
        {
          io: File.open(Rails.root.join('spec', 'files', '2.jpg')),
          filename: '2.jpg',
          content_type: 'image/jpeg'
        }
      ])

      post.song.attach(
        io: File.open(Rails.root.join('spec', 'files', 'sample2.mp3')),
        filename: 'sample2.mp3',
        content_type: 'audio/mpeg'
      )
    end
  end
end
