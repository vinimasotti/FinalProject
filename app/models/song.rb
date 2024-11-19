class Song < ApplicationRecord
   validates :title, presence: true
   validate :audio_file_presence

   has_one_attached :audio_file

   #belongs_to :user
   #belongs_to :user
   #has_many :comments
   #has_many :likes
 
   private
 
   def audio_file_presence
     errors.add(:audio_file, "must be attached") unless audio_file.attached?
   end
 end