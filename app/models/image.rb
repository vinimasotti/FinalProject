class Image < ApplicationRecord

    belongs_to :post
    has_one_attached :file 
end
