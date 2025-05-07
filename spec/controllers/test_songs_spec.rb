# spec/controllers/songs_controller_spec.rb
require 'rails_helper'
# 9 examples - 4 failed
# review CRUD operations
#
RSpec.describe SongsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    {
      title: 'Valid Song Title',
      artist: 'Valid Artist',
      user_id: user.id,
      audio_file: fixture_file_upload(Rails.root.join('spec', 'files', 'sample2.mp3'), 'audio/mpeg')
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      artist: '',
      user_id: nil
    }
  end

  before do
    sign_in user
  end
# test 1 pass
  describe 'GET #index' do
    it 'assigns all songs' do
        song1 = FactoryBot.create(:song, user: user)
        song2 = FactoryBot.create(:song, user: other_user)

      get :index

      #expect(assigns(:songs)).to include(song1, song2)
      expect(response).to have_http_status(:ok)
    end
  end
# test 2 passed 
  describe 'GET #show' do
    let(:song) { FactoryBot.create(:song, user: user) }

    it 'assigns the requested song' do
      get :show, params: { id: song.id }

     # expect(assigns(:song)).to eq(song)
      expect(response).to have_http_status(:ok)
    end
  end
# test 3 passed to get http_status
  describe 'GET #new' do
    it 'assigns a new song' do
      get :new

      #expect(assigns(:song)).to be_a_new(Song)
      expect(response).to have_http_status(:ok)
    end
  end
# test 4 pass - song created and added 1
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new song' do
        expect {
          post :create, params: { song: valid_attributes }
        }.to change(Song, :count).by(1)

        expect(response).to redirect_to(song_path(Song.last))
        expect(flash[:notice]).to be_present
      end
    end
# test 5 fail - expected with invalid_attributes
    context 'with invalid params' do
      it 'does not create a song and re-renders new' do
        post :create, params: { song: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
# test 6 fail #no coded inside the method, should be removed or improved
  describe 'GET #edit' do 
    let(:song) { FactoryBot.create(:song, user: user) }

    it 'assigns the requested song' do
      get :edit, params: { id: song.id }

      expect(assigns(:song)).to eq(song)
      expect(response).to have_http_status(:ok)
    end
  end
# test 7 fail # same as above patch updated is not on the controller
  describe 'PATCH #update' do
    let(:song) { FactoryBot.create(:song, user: user) }

    context 'with valid params' do
      let(:new_attributes) { { title: 'Updated Title', artist: 'Updated Artist' } }

      it 'updates the song' do
        patch :update, params: { id: song.id, song: new_attributes }
        song.reload

        expect(song.title).to eq('Updated Title')
        expect(song.artist).to eq('Updated Artist')
        expect(response).to redirect_to(song_path(song))
        expect(flash[:notice]).to be_present
      end
    end
# test 8 fail - expected to fail without parameters
    context 'with invalid params' do
      it 'does not update and re-renders edit' do
        patch :update, params: { id: song.id, song: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end
# test 9 pass - user can delete their own song - check the html logic
  describe 'DELETE #destroy' do
    let!(:song) { FactoryBot.create(:song, user: user) }

    it 'destroys the song' do
      expect {
        delete :destroy, params: { id: song.id }
      }.to change(Song, :count).by(-1)

      expect(response).to redirect_to(songs_path)
      expect(flash[:notice]).to be_present
    end
  end
end