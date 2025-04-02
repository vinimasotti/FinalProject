# app/models/song.rb
class Song < ApplicationRecord
  belongs_to :post
  has_one_attached :audio_file
 
  #belongs_to :user
  #validates :user, presence: true

  validates :title, presence: true
  validates :artist, presence: true
  validate :audio_file_must_be_mp3

  private

  def audio_file_must_be_mp3
    if audio_file.attached? && !audio_file.blob.content_type.in?(%w(audio/mpeg audio/mp3))
      errors.add(:audio_file, 'must be an MP3 file')
    end
  end
end