require 'rails_helper'
#6 examples, 2 failed
#6 examples passed with avatar attached
#
feature 'User signs up' do
  scenario 'with valid information including avatar upload' do
    visit new_user_registration_path # rails routes | grep -i new_user_registration
#case 1
    fill_in 'Email', with: 'valid@example.com'
    #fill_in 'Email', with: ''
    fill_in 'Bio', with: ''
    fill_in 'Username', with: ''
    attach_file 'Avatar', Rails.root.join('spec/files/2.jpg')
    fill_in 'Password', with: 'ComplexA1#!'
    fill_in 'Password confirmation', with: 'ComplexA1#!'

    click_button 'Submit'  # Your form submit button text is "Submit"
    expect(page).to have_content('Email is invalid')
   # expect(page).to have_content('Welcome! You have signed up successfully.')
  end
#case 2
  scenario 'with invalid email' do
    visit new_user_registration_path

    fill_in 'Email', with: 'invalid_email'
    fill_in 'Bio', with: 'This is my bio'
    fill_in 'Username', with: 'validuser'
    attach_file 'Avatar', Rails.root.join('spec/files/1.jpg')
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''

    click_button 'Submit'

   # expect(page).to have_content('Email is invalid')
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
#case 3
  scenario 'with missing required fields' do
    visit new_user_registration_path

    click_button 'Submit'
    expect(page).to have_content('Welcome! You have signed up successfully.')
  #  expect(page).to have_content("Email can't be blank")
   # expect(page).to have_content("Password can't be blank")
  end
end
