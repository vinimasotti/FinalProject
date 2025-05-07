
require 'rails_helper'
# 11 examples, 2 failures
#
feature 'Navbar' do
  let!(:user) { FactoryBot.create(:user) }

  context 'when user is not signed in' do
    scenario 'shows brand and no user links' do
      visit root_path

      # Brand link goes to root_path
      expect(page).to have_link('Home', href: root_path)

      # Brand text visible
      expect(page).to have_content('AudioGram')

      # No links that require login
      expect(page).not_to have_link('My Profile')
      expect(page).not_to have_link('New Post')
      expect(page).not_to have_link('Posts')
      expect(page).not_to have_link('New Song')
      expect(page).not_to have_link('Songs')
      expect(page).not_to have_link('Sign out')

      # No search form
      expect(page).not_to have_selector('form input[type="search"]')
    end
  end

  context 'when user is signed in' do
    before do
      # Attach avatar to user for testing avatar display
      user.avatar.attach(
        io: File.open(Rails.root.join('spec/files/avatar.png')),
        filename: 'avatar.png',
        content_type: 'image/png'
      )

      sign_in(user)
      visit posts_path
    end

    scenario 'shows user navigation links and avatar' do
      # Brand link goes to posts_path
      expect(page).to have_link('Home', href: posts_path)

      # Search form present
      expect(page).to have_selector('form input[type="search"][placeholder="Song Search"]')

      # User navigation links
      expect(page).to have_link('My Profile', href: user_path(user))
      expect(page).to have_link('New Post', href: new_post_path)
      expect(page).to have_link('Posts', href: posts_path)
      expect(page).to have_link('New Song', href: new_song_path)
      expect(page).to have_link('Songs', href: songs_path)
      expect(page).to have_link('Sign out', href: destroy_user_session_path)

      # Avatar image present with correct style
      expect(page).to have_css("img[src*='avatar.png'][style*='width: 50px; height: 50px;']")

      # Navbar toggler button present (for mobile)
      expect(page).to have_selector('button.navbar-toggler')
    end
  end
end
