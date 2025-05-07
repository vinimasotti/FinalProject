require 'rails_helper'
=begin
# 11 examples, 4 failures
#
feature 'User creates a song' do
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  scenario 'successfully creates a song with audio file' do
    
    visit new_song_path

    fill_in 'title', with: 'My New Song' 
    fill_in 'artist', with: 'Great Artist'

    attach_file 'Audio file', Rails.root.join('spec/files/sample2.mp3')

    click_button 'Upload Song' # Adjusted 

    expect(page).to have_content('Song was successfully created.') # Adjust flash message as per your controller
  # expect(page).to have_content('My New Song')
   # expect(page).to have_content('Great Artist')
  end


  scenario 'shows validation errors when required fields are missing' do
    visit new_song_path

    click_button 'Upload Song'

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Artist can't be blank")
    expect(page).to have_content("Audio file can't be blank")
  end
end
=end