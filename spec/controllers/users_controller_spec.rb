require 'rails_helper'

feature 'Sign up, login and logout', type: :feature do
  feature 'Sign up a new User' do
    scenario 'Sign up is invalid' do
      new_registration_path(nil, 'test@gmail.com', '123456', '123456')

      expect(current_path).to eq('/users/sign_up')
      expect(page).to have_content('errors prohibited this user from being saved')
      expect(page).to have_content("Name can't be blank")
    end

  #   scenario 'Sign up with valid params' do
  #     sign_up_user('test user', 'test@gmail.com')

  #     expect(current_path).to eq('/')
  #     expect(page).to have_content('User was successfully created and logged in')
  #   end

  #   scenario 'Log in with valid params' do
  #     sign_up_user('test user', 'test@gmail.com')
  #     logout_user
  #     login_user('test@gmail.com')
  #     expect(current_path).to eq('/')
  #     expect(page).to have_content('User logged in successfully')
  #   end
  end
end