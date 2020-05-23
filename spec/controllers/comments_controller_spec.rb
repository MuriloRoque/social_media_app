require 'rails_helper'
require 'capybara/rspec'

describe 'Comment controller', type: :feature do
  before :each do
    l = User.new(name: 'lucky', email: 'lucky@gmail.com', password: '1234567')
    l.save
    m = User.new(name: 'murilo', email: 'murilo@gmail.com', password: '8710111213')
    m.save
    f = Friendship.new(user_id: 1, friend_id: 2, confirmed: true)
    f.save
    visit '/users/sign_in'
    within('form') do
      fill_in 'user[email]', with: 'murilo@gmail.com'
      fill_in 'user[password]', with: '8710111213'
    end
    click_button 'Log in'
  end
  it 'it commments in a post' do
    visit '/posts'
    within('form') do
      fill_in 'post[content]', with: 'like your post'
    end
    click_button 'Save'
    within('#new_comment') do
      fill_in 'comment[content]', with: 'something'
    end
    click_button 'Comment'
    expect(page).to have_content 'something'
  end
end
