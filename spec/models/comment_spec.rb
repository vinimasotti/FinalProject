require 'rails_helper'
#8 examples, 1 failure
#
RSpec.describe Comment, type: :model do
  let(:post) { FactoryBot.create(:post) }
  let(:valid_attributes) do
    {
      text: 'This is a valid comment text under 300 characters.',
      post: post
    }
  end
# case 1
   describe 'validations' do
   it 'is valid with valid attributes' do
       comment = described_class.new(valid_attributes)
       expect(comment).to be_valid
    end
# case 2
     context 'text validation' do
       it { should validate_presence_of(:text) }
# case 3   
       it 'is invalid without text' do
         comment = described_class.new(valid_attributes.merge(text: nil))
       expect(comment).not_to be_valid
         expect(comment.errors[:text]).to include("can't be blank")
       end
# case 4
       it 'is invalid with text longer than 300 characters' do
         comment = described_class.new(valid_attributes.merge(text: 'a' * 301))
        expect(comment).not_to be_valid
      expect(comment.errors[:text]).to include('is too long (maximum is 300 characters)')
       end

       it 'is valid with exactly 300 characters' do
         comment = described_class.new(valid_attributes.merge(text: 'a' * 300))
         expect(comment).to be_valid
       end
     end
   end

 describe 'associations' do
     it { should belong_to(:post) }

     it 'belongs to a post' do
       comment = described_class.create(valid_attributes)
       expect(comment.post).to eq(post)
     end
#test case s
     it 'deletes comment when post is deleted' do
       comment = described_class.create(valid_attributes)
       expect {
         post.destroy
       }.to change(described_class, :count).by(-1)
     end
   end

   describe 'database' do
  
   end
end
