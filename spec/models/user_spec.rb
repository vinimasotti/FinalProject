 
require 'rails_helper'
# 14 examples, 1 failures
#
RSpec.describe User, type: :model do
  

#it "can run tests" do 
# expect(true).to be(true) 
# end

  subject { FactoryBot.build(:user) } # spec/factories/users.rb.

  describe 'validations' do
    # Devise adds presence validation on email and password by default
#case 1 - email
    it { should validate_presence_of(:email) }

#case 2 - Password validation
    it 'validates password presence on create' do
      user = FactoryBot.build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
#case 3 - Password validation with minimum length
    it 'validates password length minimum 8 characters' do
      user = FactoryBot.build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end
#case 4 -Password validation complexity - fail if not follow the rules 
    it 'validates password complexity' do
      # Assuming your password_complexity validator requires at least one uppercase, one digit, etc.
      user = FactoryBot.build(:user, password: 'ComplexA#1', password_confirmation: 'ComplexA1#!')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(/complexity/i)
    end
#case 5 - validation with complex password
    it 'is valid with a complex password of minimum length' do
      user = FactoryBot.build(:user, password: 'Complex1!', password_confirmation: 'Complex1!')
      expect(user).to be_valid
    end
  end
#case 6 - admin or user?
  describe 'enum role' do
    it 'has default role admin' do
      user = FactoryBot.build(:user)
      expect(user.role).to eq('user')
    end
# case 7 - allow settings to role user
    it 'allows setting role to admin' do
      user = FactoryBot.build(:user, role: :admin)
      expect(user.role).to eq('admin')
    end
  end
#case 8 to 12 - associations 
  describe 'associations' do
    it { should have_many(:songs).dependent(:destroy) }
    #it { should have_one(:storage).dependent(:destroy) } # Storage model is created but will be used for future implementations
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments) }
    it { should have_one_attached(:avatar) }
  end
# case 13 - database callback - no methods yet inside storage but it created.
  describe 'callbacks' do
    it 'creates storage after user creation' do
      user = FactoryBot.create(:user)
      expect(user.storage).to be_present
    end

#case 14 - randomize id test
    it 'randomizes id before create' do
      user = FactoryBot.create(:user)
      expect(user.id).to be_a(Integer)
      expect(user.id).to be < 1_000_000_000
    end
  end
end


