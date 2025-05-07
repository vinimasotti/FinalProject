require 'rails_helper'
# 15 examples, 3 expected failures
#

RSpec.describe Song, type: :model do
  # Include Shoulda Matchers for RSpec
  # Use FactoryBot to create a user and a valid song
  let(:user) { FactoryBot.create(:user) }
  let(:valid_song) { FactoryBot.build(:song, user: user) }
  
#case 1 and 2
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one_attached(:audio_file) }
  
#case 3
  describe 'validations' do
    it 'is valid with valid attributes and attached mp3' do
      expect(valid_song).to be_valid
    end
#case 4
    it 'is invalid without a title' do
      valid_song.title = nil
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:title]).to include("can't be blank")
    end
#case 5
    it 'is invalid if title is too short' do
      valid_song.title = 'abc'
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:title]).to include('is too short (minimum is 5 characters)')
    end
#case 6
    it 'is invalid if title is too long' do
      valid_song.title = 'a' * 51
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:title]).to include('is too long (maximum is 50 characters)')
    end
#case 7
    it 'is invalid without an artist' do
      valid_song.artist = nil
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:artist]).to include("can't be blank")
    end
#case 8
    it 'is invalid if artist is too short' do
      valid_song.artist = 'ab'
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:artist]).to include('is too short (minimum is 3 characters)')
    end
#case 9
    it 'is invalid if artist is too long' do
      valid_song.artist = 'a' * 51
      expect(valid_song).not_to be_valid
      expect(valid_song.errors[:artist]).to include('is too long (maximum is 50 characters)')
    end
#case 10
    context 'audio_file validations' do
      it 'is invalid without an attached audio_file' do
        valid_song.audio_file.detach
        expect(valid_song).not_to be_valid
        expect(valid_song.errors[:audio_file]).to include("can't be blank")
      end
#case 11 positive fail
      it 'is invalid if audio_file is not an mp3' do
        # Attach a non-mp3 file
        valid_song.audio_file.detach
        valid_song.audio_file.attach(
          io: File.open(Rails.root.join('spec', 'files', '1.jpg')),
          filename: '1.jpg',
          content_type: 'text/plain'
        )
        expect(valid_song).not_to be_valid
        expect(valid_song.errors[:audio_file]).to include('must be an MP3 file')
      end
#case 12  REVIEW - it should be fixed to not accept files more than 50 mb
      it 'is invalid if audio_file size exceeds 50 MB' do
        # Mock the blob byte size to simulate large file
        allow(valid_song.audio_file.blob).to receive(:byte_size).and_return(51.megabytes)
        expect(valid_song).not_to be_valid
        expect(valid_song.errors[:audio_file]).to include('size must be less than 50 MB')
      end
    end
#case 13 - 
    context 'total storage limit validation' do
      it 'is valid if total storage is under 1 GB' do
        expect(valid_song).to be_valid
      end
#case 14 -  REVIEW - it should be fixed to not accept total upload more than 1 GB
      it 'is invalid if total storage exceeds 1 GB' do
        # Create an existing song for the user (not strictly necessary if stubbing)
        existing_song = FactoryBot.create(:song, user: user)
        # Stub the ActiveStorage query chain to return a total size close to 1 GB
        allow(ActiveStorage::Blob).to receive_message_chain(:joins, :where, :sum).and_return(1.gigabyte - 10.megabytes)

        # Stub the current song's audio_file blob size to 20 MB (which pushes total over 1 GB)
        allow(valid_song.audio_file.blob).to receive(:byte_size).and_return(20.megabytes)
      
        # Validate the song to trigger custom validation
        valid_song.validate
      
        expect(valid_song.errors[:audio_file]).to include('upload 
              exceeds your total storage limit of 1 GB')
      end
    end
  end
#case 15
  describe 'scopes' do
    describe '.owned_by' do
      it 'returns songs owned by the specified user' do
        song1 = FactoryBot.create(:song, user: user)
        other_user = FactoryBot.create(:user)
        song2 = FactoryBot.create(:song, user: other_user)

        expect(Song.owned_by(user)).to include(song1)
        expect(Song.owned_by(user)).not_to include(song2)
      end
    end
  end
end
end
