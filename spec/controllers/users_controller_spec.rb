require 'rails_helper'
require 'capybara/rspec'

describe 'Users controller', type: :feature do
  before :each do
    l = User.new(name: 'lucky', email: 'lucky@gmail.com', password: '1234567')
    l.save
    m = User.new(name: 'murilo', email: 'murilo@gmail.com', password: '1234567')
    m.save
    d = User.new(name: 'daniela', email: 'daniela@gmail.com', password: '1234567')
    d.save
    f = Friendship.new(user_id: l.id, friend_id: m.id, confirmed: false)
    f.save
    visit '/users/sign_in'
    within('form') do
      fill_in 'user[email]', with: 'murilo@gmail.com'
      fill_in 'user[password]', with: '1234567'
    end
    click_button 'Log in'
  end
  it 'rejects a friend request' do
    visit '/users'
    click_link 'reject'
    expect(page).to have_content 'Request Friendship'
  end
  it 'accepts a friend request' do
    visit '/users'
    click_link 'accept'
    expect(page).to have_content 'Unfriend'
  end
  it 'sends a friend request' do
    visit '/users'
    click_link 'send-request'
    expect(page).to have_content 'Cancel Request'
  end
end
