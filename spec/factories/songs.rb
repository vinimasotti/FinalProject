FactoryBot.define do
  factory :song do

     title { "Valid Song Title" }
    artist { "Valid Artist" }
    association :user

    # Attach a valid MP3 audio_file after build
    after(:build) do |song|
      # Attach a dummy mp3 file using fixture_file_upload or similar
      song.audio_file.attach(
        io: File.open(Rails.root.join('spec', 'files', 'sample2.mp3')),
        filename: 'sample2.mp3',
        content_type: 'audio/mpeg'
      )
    end
    
  end
end
