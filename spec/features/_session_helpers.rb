# spec/support/features/session_helpers.rb
module Features
    module SessionHelpers
      def sign_up(email, password)
        visit new_user_registration_path
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_button 'Sign up'
      end
  
      def sign_in(user)
        visit new_user_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end
    end
  end
  
  # spec/rails_helper.rb or spec/spec_helper.rb
  RSpec.configure do |config|
    config.include Features::SessionHelpers, type: :feature
  end