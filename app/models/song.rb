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

  validate :total_storage_limit_not_exceeded

  MAX_STORAGE_BYTES = 1.gigabyte

  def total_storage_limit_not_exceeded
    return unless audio_file.attached?

    # Sum sizes of all blobs attached to user's songs except this one if it exists (for update)
    existing_total = ActiveStorage::Blob.joins(:attachments)
      .where(active_storage_attachments: { record_type: 'Song', record_id: user.songs.where.not(id: id).select(:id) })
      .sum(:byte_size)

    new_file_size = audio_file.blob.byte_size

    if existing_total + new_file_size > MAX_STORAGE_BYTES
      errors.add(:audio_file, "upload exceeds your total storage limit of #{MAX_STORAGE_BYTES / 1.gigabyte} GB")
    end
  end

  
end


  private

  def audio_file_must_be_mp3
    if audio_file.attached? && !audio_file.blob.content_type.in?(%w(audio/mpeg audio/mp3))
      errors.add(:audio_file, 'must be an MP3 file')
    end
  end
