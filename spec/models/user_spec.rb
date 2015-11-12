require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(position: :asc) }

  describe '#queued_video?' do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }

    context 'when the user queued the video' do
      before { Fabricate(:queue_item, user: user, video: video) }

      it 'returns true' do
        expect(user.queued_video?(video)).to eq(true)
      end
    end

    context 'when the user has not queued the video' do
      it 'returns false' do
        expect(user.queued_video?(video)).to eq(false)
      end
    end
  end
end