require 'rails_helper'
#8 examples, 6 failures
#User post data structure should be reviewed 
#User search method should be reviewed or deleted.
#
RSpec.describe UsersController, type: :controller do
  # Include Devise test helpers to simulate sign_in
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  #FactoryBot create a user to be used in the tests cases
  before do
    sign_in user
  end

#case 1 FAILING
  describe 'GET #users' do
    it 'assigns @users based on search query' do
      matching_user = FactoryBot.create(:user, username: 'search_target')
      non_matching_user = FactoryBot.create(:user, username: 'other')

      get :users, params: { query: 'search' }

      expect(assigns(:users)).to include(matching_user)
      expect(assigns(:users)).not_to include(non_matching_user)
    end
#case 2 FAILED!
    it 'assigns all users if query is blank' do
      all_users = FactoryBot.create_list(:user, 3)

      get :users, params: { query: '' }

      expect(assigns(:users)).to match_array(User.all)
    end
end

#case 3 FAILED!

  describe 'GET #index' do
    it 'assigns @q and @users' do
      users = FactoryBot.create_list(:user, 2)

      get :index

      expect(assigns(:q)).to be_a(Ransack::Search)
      expect(assigns(:users)).to match_array(User.all)
    end
  end

#case 4 FAILED!
  describe 'GET #show' do
    before do
      # Stub methods used in show action
      allow(user).to receive(:total_uploaded_data_size).and_return(100.megabytes)
      allow(user).to receive(:total_uploaded_song_data_size).and_return(200.megabytes)
      allow(user).to receive(:username).and_return('username')
      allow(controller.current_user).to receive(:following?).with(user).and_return(false)
      allow(controller.current_user).to receive(:sent_follow_request_to?).with(user).and_return(false)
    end
#case 5 fail
    it 'assigns user and related instance variables' do
      get :show, params: { id: user.id }

      expect(assigns(:user)).to eq(user)
      expect(assigns(:total_uploaded_data_size)).to eq(100.megabytes)
      expect(assigns(:total_uploaded_song_data_size)).to eq(200.megabytes)
      expect(assigns(:total_combined_data_size)).to eq(300.megabytes)
      expect(assigns(:exceeds_data_limit)).to eq(false)
      expect(assigns(:is_following)).to eq(false)
      expect(assigns(:sent_follow_request)).to eq(false)
      expect(assigns(:is_current_user)).to eq(true)
    end
  end

#case 6 FAIL

  describe 'POST #follow' do
    before do
      allow(controller.current_user).to receive(:send_follow_request_to).with(other_user)
      allow(other_user).to receive(:accept_follow_request_of).with(controller.current_user)
    end

    it 'sends follow request and accepts it, then redirects with notice' do
      post :follow, params: { id: other_user.id }

      expect(controller.current_user).to have_received(:send_follow_request_to).with(other_user)
      expect(other_user).to have_received(:accept_follow_request_of).with(controller.current_user)
      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:notice]).to eq("You are now following #{other_user.username}.")
    end
  end

#case 7 PASSED
  describe 'POST #unfollow' do
    before do
      allow(controller.current_user).to receive(:following?).with(other_user).and_return(true)
      allow(controller.current_user).to receive(:unfollow).with(other_user)
    end

    it 'unfollows user if following and redirects with notice' do
      post :unfollow, params: { id: other_user.id }

      expect(controller.current_user).to have_received(:following?).with(other_user)
      expect(controller.current_user).to have_received(:unfollow).with(other_user)
      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:notice]).to eq("You have unfollowed #{other_user.username}.")
    end

    it 'does not unfollow if not following' do
      allow(controller.current_user).to receive(:following?).with(other_user).and_return(false)

      post :unfollow, params: { id: other_user.id }

      expect(controller.current_user).not_to have_received(:unfollow)
      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:notice]).to eq("You have unfollowed #{other_user.username}.")
    end
  end

#case 8 FAIL
  describe 'GET #posts' do
    let!(:posts) { FactoryBot.create_list(:post, 3, user: other_user) }

    it 'assigns @user and @posts ordered by created_at desc' do
      get :posts, params: { user_id: other_user.id }

      expect(assigns(:user)).to eq(other_user)
      expect(assigns(:posts)).to eq(posts.sort_by(&:created_at).reverse)
    end
  end

end
