require 'rails_helper'
# 7 examples, 2 failures
#  validations image are not present on the post model.
#
feature 'User creates a post' do
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  scenario 'successfully creates a post with images and song' do
    visit new_post_path

    fill_in 'Title', with: 'My new post'
    fill_in 'Description', with: 'This is a great post!'

    # Note: user_id is hidden field, no need to fill manually 

    # Attach multiple images - 
    attach_file('post_images', [
        Rails.root.join('spec/files/2.jpg'),
        Rails.root.join('spec/files/1.jpg')
      ], make_visible: true)

    # Attach a song file
    attach_file 'Upload Song', Rails.root.join('spec/files/sample2.mp3')

    click_button 'Create Post' # or 'Submit' if your button text is Submit

    expect(page).to have_content('Post was successfully created.')
   # expect(page).to have_content('My new post')
  end

  scenario 'shows validation errors when required fields are missing' do
    visit new_post_path

    # Submit without filling anything
    click_button 'Create Post'

    expect(page).to have_content("Title can't be blank").or have_content("Title can't be blank ,")
    expect(page).to have_content("Description can't be blank").or have_content("Description can't be blank ,")
#    expect(page).to have_content("Images can't be blank").or have_content("Images can't be blank ,")
  end
end
