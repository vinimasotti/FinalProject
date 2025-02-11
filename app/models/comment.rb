class Comment < ApplicationRecord

    belongs_to :post
    validates :text, presence: true, length: { maximum: 300 }

end
