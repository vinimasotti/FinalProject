class Song < ApplicationRecord # Inherited class 
   validates :title, presence: true #Ensure the title and audio is not null to add
   validates :audio_file, presence: true
   has_one_attached :audio_file

   #belongs_to :user # owner of the song
   #has_many :comments # allowing comments 
   #has_many :likes # allowing likes 
   
   before_create :randomize_id # randomizing id method to get unique id
   private
   def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000) # generate a loop between 0 and 1 billion
    end while User.where(id: self.id).exists? # ensure to not get the same id
  end
   private # check if the file is attached
 
   def audio_file_presence
     errors.add(:audio_file, "must be attached") unless audio_file.attached?
   end
 end