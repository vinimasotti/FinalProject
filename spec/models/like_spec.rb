require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, user: user) }
  let(:like) { FactoryBot.build(:like, user: user, post: post) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(like).to be_valid
    end

    it 'is invalid without a user' do
      like.user = nil
      expect(like).not_to be_valid
      expect(like.errors[:user]).to include("must exist")
    end

    it 'is invalid without a post' do
      like.post = nil
      expect(like).not_to be_valid
      expect(like.errors[:post]).to include("must exist")
    end

    it 'is invalid if the same user likes the same post multiple times' do
      like.save
      duplicate_like = Like.new(user: user, post: post)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:base]).to include("You have already liked this post.")
    end
  end
end
