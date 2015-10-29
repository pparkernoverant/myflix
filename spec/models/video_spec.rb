require 'spec_helper'

describe Video do
  it { should have_and_belong_to_many :categories }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  describe 'search_by_title' do
    it 'returns an empty array if there is no match' do
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1')
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2')

      expect(Video.search_by_title('test_video_3')).to eq([])
    end

    it 'returns an array of one video for an exact match' do
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1')

      expect(Video.search_by_title('test_video_1')).to eq([vid_1])
    end
    
    it 'returns an array of one video for a partial match' do
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1')

      expect(Video.search_by_title('test_video')).to eq([vid_1])
    end
    
    it 'returns an array of all matches ordered by created_at' do
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1', created_at: 1.day.ago)
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2', created_at: 2.days.ago)

      expect(Video.search_by_title('test_video')).to eq([vid_1, vid_2])
    end

    it 'returns an empty array for a search on an empty string' do
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1')

      expect(Video.search_by_title('')).to eq([])
    end
  end
end