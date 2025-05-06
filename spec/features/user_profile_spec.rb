require 'rails_helper'
# 17 example, 15 failed
#
feature 'User profile page' do
  let!(:user) { FactoryBot.create(:user, username: 'profileuser', bio: 'User bio') }
  let!(:other_user) { FactoryBot.create(:user, username: 'otheruser') }

  before do
    # Attach avatar to user
    user.avatar.attach(
      io: File.open(Rails.root.join('spec/files/2.jpg')),
     filename: '2.jpg',
     content_type: 'image/jpg'
    )

    # Create posts, likes, songs for user
    FactoryBot.create_list(:post, 3, user: user)
    FactoryBot.create_list(:like, 5, user: user, post: FactoryBot.create(:post))
    FactoryBot.create_list(:song, 2, user: user)

    # Setup followers/following relationships
    user.followers << other_user
    user.following << other_user

    # Stub methods for uploaded data sizes (if these are methods on User model)
    allow(user).to receive(:total_uploaded_data_size).and_return(500.megabytes)
    allow(user).to receive(:total_uploaded_song_data_size).and_return(600.megabytes)
  end

  context 'when signed in as the profile owner' do #
    before do
      sign_in(user)
      visit user_path(user)
    end

    scenario 'displays user information and statistics' do
      expect(page).to have_content('Username: profileuser')
      expect(page).to have_content('Bio : User bio')
      expect(page).to have_content("E-mail: #{user.email}")
      expect(page).to have_content('Total Posts: 3')
      expect(page).to have_content('Total Likes: 5')
      expect(page).to have_content('Total Songs: 2')

      # Avatar image presence
      expect(page).to have_css("img[src*='2.jpg']")

      # Posts link
      expect(page).to have_link('View Posts', href: user_posts_path(user))

      # Edit Account button visible
      expect(page).to have_button('Edit Account')

      # Uploaded data sizes
      expect(page).to have_content('Post Data Uploaded:')
      expect(page).to have_content('Song Data Uploaded:')
      expect(page).to have_content('Total Uploaded Data (Combined):')

      # Warning message because combined > 1 GB
      expect(page).to have_content('Warning: You have exceeded 1 GB of data upload.')
    end

    scenario 'does not show Follow/Unfollow buttons for self' do
      expect(page).not_to have_button('Follow')
      expect(page).not_to have_button('Unfollow')
    end

    scenario 'displays followers and following usernames with links' do
      user.followers.each do |follower|
        expect(page).to have_link(follower.username, href: user_path(follower))
      end

      user.following.each do |following|
        expect(page).to have_link(following.username, href: user_path(following))
      end
    end
  end

  context 'when signed in as a different user' do
    before do
      sign_in(other_user)
      visit user_path(user)
    end

    scenario 'shows Follow button if not following' do
      # Stub following? to false to simulate not following
      allow(other_user).to receive(:following?).with(user).and_return(false)

      visit user_path(user)

      expect(page).to have_button('Follow')
      expect(page).not_to have_button('Unfollow')
      expect(page).not_to have_button('Edit Account')
    end

    scenario 'shows Unfollow button if following' do
      # Stub following? to true to simulate following
      allow(other_user).to receive(:following?).with(user).and_return(true)

      visit user_path(user)

      expect(page).to have_button('Unfollow')
      expect(page).not_to have_button('Follow')
      expect(page).not_to have_button('Edit Account')
    end

    scenario 'does not show Edit Account button' do
      expect(page).not_to have_button('Edit Account')
    end
  end

  context 'when not signed in' do
    before do
      visit user_path(user)
    end

    scenario 'does not show user info (because of your view logic)' do
      # Your view shows content only if user_signed_in?
      expect(page).not_to have_content('Username:')
      expect(page).not_to have_content(user.username)
    end
  end
end