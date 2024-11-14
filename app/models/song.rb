class Song < ApplicationRecord

   # validates :title, presence: true, length: { minimum: 5, maximum: 100 }
    
    has_one_attached :audio_file

   # belongs_to :user

end
