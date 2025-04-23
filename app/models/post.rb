class Post < ApplicationRecord

    validates :title, presence: true, length: { minimum: 5, maximum: 100 }
    validates :description, presence: true, length: { minimum: 5, maximum: 500 }
    #validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    #validates :artist, presence: true, length: { minimum: 3, maximum: 50 }
   # validates :keywords, presence: true, length: { minimum: 3, maximum: 100 }
    
    #validates :content, presence: true

    #has_many :songs, dependent: :destroy
    has_one_attached :audio_file 
    has_many_attached :images
    has_one_attached :song

    belongs_to :user 
   # belongs_to :post
    has_many :comments
    has_many :likes, dependent: :destroy 
  

    before_create :randomize_id
         private
         def randomize_id
          begin
            self.id = SecureRandom.random_number(1_000_000_000)
          end while User.where(id: self.id).exists?
        end
end
