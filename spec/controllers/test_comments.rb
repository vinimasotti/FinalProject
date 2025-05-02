require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:comment) { create(:comment) } # Assuming a FactoryBot factory exists for Comment
  let!(:user) { create(:user) }       # Assuming a FactoryBot factory exists for User

  # Authenticate the user before each test
  before do
    sign_in user # Assuming Devise is used for authentication
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: comment.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: { post_id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: comment.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new comment and redirects to the associated post" do
      expect {
        post :create, params: { comment: { text: "Test comment", post_id: 1, user_id: user.id } }
      }.to change(Comment, :count).by(1)

      expect(response).to redirect_to(Comment.last.post)
    end

    it "renders :new when comment creation fails" do
      post :create, params: { comment: { text: "", post_id: nil, user_id: nil } }
      expect(response).to render_template(:new)
    end
  end

  describe "PATCH/PUT #update" do
    it "updates the comment and redirects to the comment" do
      patch :update, params: { id: comment.id, comment: { text: "Updated text" } }
      comment.reload
      expect(comment.text).to eq("Updated text")
      expect(response).to redirect_to(comment)
    end

    it "renders :edit when update fails" do
      patch :update, params: { id: comment.id, comment: { text: "" } }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the comment and redirects to the comments index" do
      expect {
        delete :destroy, params: { id: comment.id }
      }.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(comments_path)
    end
  end
end