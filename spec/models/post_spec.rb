

require 'rails_helper'
#15 example, 0 failures 
# 7 validations and 7 associations

RSpec.describe Post, type: :model do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_attributes) do
        {
            title: 'Valid  Post Title',
           # title: 'Invalid Post Title' * 10,
           # title: '',

           # description: 'invalid entry' * 500,
            description: 'valid entry',
          #  description: '',
            user: user
        }
    end
#case 1
    describe 'validations' do
        it 'is valid with valid attributes' do
            post = described_class.new(valid_attributes)
            expect(post).to be_valid
        end
#case 2
        it 'is invalid without a title' do
            post = described_class.new(valid_attributes.merge(title: nil))
            expect(post).not_to be_valid
            expect(post.errors[:title]).to include("can't be blank")
        end
#case 3
        it 'is invalid if title is too short' do
            post = described_class.new(valid_attributes.merge(title: 'abc'))
            expect(post).not_to be_valid
            expect(post.errors[:title]).to include('is too short (minimum is 5 characters)')
        end
#case 4
        it 'is invalid if title is too long' do
            post = described_class.new(valid_attributes.merge(title: 'a' * 101))
            expect(post).not_to be_valid
            expect(post.errors[:title]).to include('is too long (maximum is 100 characters)')
        end
#case 5
        it 'is invalid without a description' do
            post = described_class.new(valid_attributes.merge(description: nil))
            expect(post).not_to be_valid
            expect(post.errors[:description]).to include("can't be blank")
        end
#case 6
        it 'is invalid if description is too short' do
            post = described_class.new(valid_attributes.merge(description: 'abc'))
            expect(post).not_to be_valid
            expect(post.errors[:description]).to include('is too short (minimum is 5 characters)')
        end
#case 7
        it 'is invalid if description is too long' do
            post = described_class.new(valid_attributes.merge(description: 'a' * 501))
            expect(post).not_to be_valid
            expect(post.errors[:description]).to include('is too long (maximum is 500 characters)')
        end
    end
#case 8 to case 9 - associations
    describe 'associations' do
        it { should belong_to(:user) }

        it { should have_many(:comments) }
        it { should have_many(:likes).dependent(:destroy) }
        it { should have_many(:liked_users).through(:likes).source(:user) }

        it { should have_one_attached(:audio_file) }
        it { should have_many_attached(:images) }
        it { should have_one_attached(:song) }
    end
#case 15
    describe 'callbacks' do
        it 'randomizes id before create' do
            post = described_class.create!(valid_attributes)
            expect(post.id).to be_a(Integer)
            expect(post.id).to be < 1_000_000_000
        end
    end
end
