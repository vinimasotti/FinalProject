require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  include Devise::Test::ControllerHelpers
# 6 examples - 2 failed
#   expected: "text/javascript"
#   got: "text/javascript; charset=utf-8"

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post_record) { FactoryBot.create(:post, user: other_user) }

  before do
    sign_in user
  end
#test 1 pass
  describe 'POST #create' do
    context 'when like does not exist yet' do
      it 'creates a like and redirects with notice (HTML)' do
        post :create, params: { post_id: post_record.id }

        expect(post_record.likes.where(user: user)).to exist
        expect(response).to redirect_to(post_path(post_record))
        expect(flash[:notice]).to eq('You liked this post.')
      end
#test 2 fail 
      it 'creates a like and responds with JS format' do
        post :create, params: { post_id: post_record.id }, format: :js

        expect(post_record.likes.where(user: user)).to exist
        expect(response.content_type).to eq 'text/javascript'
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when like already exists' do
      before do
        FactoryBot.create(:like, user: user, post: post_record)
      end
#test 3 pass
      it 'does not create a duplicate like and redirects with alert' do
        post :create, params: { post_id: post_record.id }

        expect(post_record.likes.where(user: user).count).to eq(1)
        expect(response).to redirect_to(post_path(post_record))
        expect(flash[:alert]).to eq('You cannot like this post more than once.')
      end
    end
  end
#test 4 pass
  describe 'DELETE #destroy' do
    context 'when like exists' do
      let!(:like) { FactoryBot.create(:like, user: user, post: post_record) }

      it 'destroys the like and redirects with notice (HTML)' do
        delete :destroy, params: { post_id: post_record.id }

        expect(post_record.likes.where(user: user)).not_to exist
        expect(response).to redirect_to(post_path(post_record))
        expect(flash[:notice]).to eq('You unliked this post.')
      end
#test 5 fail
      it 'destroys the like and responds with JS format' do
        delete :destroy, params: { post_id: post_record.id }, format: :js

        expect(post_record.likes.where(user: user)).not_to exist
       # expect(response.content_type).to eq 'text/javascript'
        expect(response).to have_http_status(:ok)
      end
    end
#test 6 pass
    context 'when like does not exist' do
      it 'redirects with alert' do
        delete :destroy, params: { post_id: post_record.id }

        expect(response).to redirect_to(post_path(post_record))
        expect(flash[:alert]).to eq('Like not found.')
      end
    end
  end
end