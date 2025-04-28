# app/models/song.rb
class Song < ApplicationRecord
 # belongs_to :post
  has_one_attached :audio_file

  validates :audio_file, content_type: /\Aaudio\/.*\z/, size: { less_than: 50.megabytes }

   # Scope to get songs owned by a user
   scope :owned_by, ->(user) { where(user: user) }
 
  belongs_to :user
# validates :user, presence: true

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :artist, presence: true, length: { minimum: 3, maximum: 50 }
  validate :audio_file_must_be_mp3

 


  private

  def audio_file_must_be_mp3
    if audio_file.attached? && !audio_file.blob.content_type.in?(%w(audio/mpeg audio/mp3))
      errors.add(:audio_file, 'must be an MP3 file')
    end
  end
end