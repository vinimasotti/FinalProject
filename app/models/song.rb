class Song < ApplicationRecord
   validates :title, presence: true
   validates :audio_file, presence: true
   has_one_attached :audio_file

   #belongs_to :user
   #has_many :comments
   #has_many :likes
   
   before_create :randomize_id
   private
   def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.where(id: self.id).exists?
  end
   private
 
   def audio_file_presence
     errors.add(:audio_file, "must be attached") unless audio_file.attached?
   end
 end