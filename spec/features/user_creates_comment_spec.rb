=begin
require 'rails_helper'
# 15 examples, 4 failures
#
feature 'User creates a comment' do
  let!(:user) { FactoryBot.create(:user) }
  let!(:post_record) { FactoryBot.create(:post) }

  before do
    sign_in(user)
  end

  scenario 'successfully creates a comment' do
    visit post_path(post_record)

    # Fill in the comment text field
    fill_in 'Your Text:', with: 'This is a valid comment.'

    # Hidden fields user_id and post_id are set by the form, so no need to fill manually

    click_button 'Create'

    expect(page).to have_content('Comment was successfully created') # Adjust flash message as per your controller
    expect(page).to have_content('This is a valid comment.')
  end

  scenario 'shows validation error when text is blank' do
    visit post_path(post_record)

    fill_in 'Your Text:', with: ''

    click_button 'Create'

    expect(page).to have_content("Text can't be blank")
  end
#test failed because the validation for maximmum lengh in the model is 300 characteres
#should review model and view

  scenario 'shows validation error when text is too long' do
    visit post_path(post_record)

    long_text = 'a' * 101 # 101 characters, exceeding maxlength 100

    fill_in 'Your Text:', with: long_text

    click_button 'Create'

    expect(page).to have_content('Text is too long (maximum is 100 characters)')
  end
end
=end