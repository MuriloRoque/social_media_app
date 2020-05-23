require 'rails_helper'
require 'capybara/rspec'

describe 'Likes controller', type: :feature do
  before :each do
    l = User.new(name: 'lucky', email: 'lucky@gmail.com', password: '1234567')
    l.save
    m = User.new(name: 'murilo', email: 'murilo@gmail.com', password: '8710111213')
    m.save
    f = Friendship.new(user_id: 1, friend_id: 2, confirmed: true)
    f.save
    visit '/users/sign_in'
    within('form') do
      fill_in 'user[email]', with: 'lucky@gmail.com'
      fill_in 'user[password]', with: '1234567'
    end
    click_button 'Log in'
  end
  it 'likes a post' do
    visit '/posts'
    within('form') do
      fill_in 'post[content]', with: 'a new post'
    end
    click_button 'Save'
    expect(page).to have_content('Like!')
  end
  it 'like a post' do
    visit '/posts'
    within('form') do
      fill_in 'post[content]', with: 'a new post'
    end
    click_button 'Save'
    click_link 'Like!'
    expect(page).to have_content('You liked a post.')
  end
end
