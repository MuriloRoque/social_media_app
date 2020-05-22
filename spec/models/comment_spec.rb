require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(200) }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
