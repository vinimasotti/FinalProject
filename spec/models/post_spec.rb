# require 'rails_helper'

# RSpec.describe Post, type: :model do
#   let(:user) { FactoryBot.create(:user) }
#   let(:valid_attributes) do
#     {
#       title: 'Valid Post Title',
#       description: 'This is a valid description with more than 5 characters.',
#       user: user
#     }
#   

#   #describe 'validations' do
#     it 'is valid with valid attributes' do
#       post = described_class.new(valid_attributes)
#       expect(post).to be_valid
#     end

#     it 'is invalid without a title' do
#       post = described_class.new(valid_attributes.merge(title: nil))
#       expect(post).not_to be_valid
#       expect(post.errors[:title]).to include("can't be blank")
#     end

#     it 'is invalid if title is too short' do
#       post = described_class.new(valid_attributes.merge(title: 'abc'))
#       expect(post).not_to be_valid
#       expect(post.errors[:title]).to include('is too short (minimum is 5 characters)')
#     end

#     it 'is invalid if title is too long' do
#       post = described_class.new(valid_attributes.merge(title: 'a' * 101))
#       expect(post).not_to be_valid
#       expect(post.errors[:title]).to include('is too long (maximum is 100 characters)')
#     end

#     it 'is invalid without a description' do
#       post = described_class.new(valid_attributes.merge(description: nil))
#       expect(post).not_to be_valid
#       expect(post.errors[:description]).to include("can't be blank")
#     end

#     it 'is invalid if description is too short' do
#       post = described_class.new(valid_attributes.merge(description: 'abc'))
#       expect(post).not_to be_valid
#       expect(post.errors[:description]).to include('is too short (minimum is 5 characters)')
#     end

#     it 'is invalid if description is too long' do
#       post = described_class.new(valid_attributes.merge(description: 'a' * 501))
#       expect(post).not_to be_valid
#       expect(post.errors[:description]).to include('is too long (maximum is 500 characters)')
#     end
#   

#   #describe 'associations' do
#     it { should belong_to(:user) }

#     it { should have_many(:comments) }
#     it { should have_many(:likes).dependent(:destroy) }
#     it { should have_many(:liked_users).through(:likes).source(:user) }

#     it { should have_one_attached(:audio_file) }
#     it { should have_many_attached(:images) }
#     it { should have_one_attached(:song) }
#   end

#   #describe 'callbacks' do
#     it 'randomizes id before create' do
#       post = described_class.create!(valid_attributes)
#       expect(post.id).to be_a(Integer)
#       expect(post.id).to be < 1_000_000_000
#     end
#   end

# ```
