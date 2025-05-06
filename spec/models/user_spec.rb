 
require 'rails_helper'
# 3 example, 0 failures
#
RSpec.describe User, type: :model do
  

  it "can run tests" do 
    expect(true).to be(true) 
  end

  subject { FactoryBot.build(:user) } # spec/factories/users.rb.

  describe 'validations' do
    # Devise adds presence validation on email and password by default
    it { should validate_presence_of(:email) }

    # Password validations
    it 'validates password presence on create' do
      user = FactoryBot.build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates password length minimum 8 characters' do
      user = FactoryBot.build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it 'validates password complexity' do
      # Assuming your password_complexity validator requires at least one uppercase, one digit, etc.
      user = FactoryBot.build(:user, password: 'ComplexA1#!', password_confirmation: 'ComplexA1#!')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(/complexity/i)
    end

    it 'is valid with a complex password of minimum length' do
      user = FactoryBot.build(:user, password: 'Complex1!', password_confirmation: 'Complex1!')
      expect(user).to be_valid
    end
  end

  describe 'enum role' do
    it 'has default role admin' do
      user = FactoryBot.build(:user)
      expect(user.role).to eq('user')
    end

    it 'allows setting role to admin' do
      user = FactoryBot.build(:user, role: :admin)
      expect(user.role).to eq('admin')
    end
  end

  describe 'associations' do
    it { should have_many(:songs).dependent(:destroy) }
    #it { should have_one(:storage).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments) }
    it { should have_one_attached(:avatar) }
  end

  describe 'callbacks' do
    it 'creates storage after user creation' do
      user = FactoryBot.create(:user)
      expect(user.storage).to be_present
    end

    it 'creates storage after user creation' do
      user = FactoryBot.create(:user)
      expect(user.commemnts).to be_present
    end

    it 'randomizes id before create' do
      user = FactoryBot.create(:user)
      expect(user.id).to be_a(Integer)
      expect(user.id).to be < 1_000_000_000
    end
  end

