class Song < ApplicationRecord
    has_one_attached :audio_file
end
