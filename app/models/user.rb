class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         :password_archivable #Ensures users cannot reuse previous password
         #password_expirable #possibility to expire password after 3 months see on devise.setup do |config| 

         validates :password, presence: true, length: { minimum: 8 }, password_complexity: true, if: :password_required?
         
        followability

        has_many :songs
         has_many :posts
         has_many :likes
         has_many :comments
         has_one_attached :avatar
         before_create :randomize_id

         #destroy relationship have same user id to unfollow
         def unfollow(user)
          followerable_relationships.where(followable_id: user.id).destroy_all
         end

         #Search button
     # Explicitly define searchable associations
     def self.ransackable_associations(auth_object = nil)
    %w[avatar_attachment avatar_blob blockers blocks comments followable_relationships followerable_relationships followers following likes posts songs]
  end
 
   # Explicitly define searchable attributes
   def self.ransackable_attributes(auth_object = nil)
    %w[username email created_at] # Add only the non-sensitive fields you want searchable
  end
         

         private
         def randomize_id
          begin
            self.id = SecureRandom.random_number(1_000_000_000)
          end while User.where(id: self.id).exists?
        end

        #enum role: [:user, :admin]
        enum role: { user: 0, admin: 1 } #updated to run on ruby 8.0

        after_initialize :set_default_role, :if => :new_record?
        def set_default_role
          self.role ||= :user #change to admin to sign a new admin 
        end     

end
