require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many :videos }
  it { should validate_presence_of :name }

  describe '#recent_videos' do
    it 'returns the videos in reverse chronical order by created at' do
      category = Category.create(name: 'test_category')
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1', category_ids: category.id, created_at: 1.day.ago)
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2', category_ids: category.id, created_at: 2.days.ago)

      expect(category.recent_videos).to eq([vid_1, vid_2])
    end

    it 'returns all the videos of there are less than 6 videos' do
      category = Category.create(name: 'test_category')
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1', category_ids: category.id, created_at: 1.day.ago)
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2', category_ids: category.id, created_at: 2.days.ago)

      expect(category.recent_videos.count).to eq(2)
    end

    it 'returns 6 videos if there are more than 6 videos' do
      category = Category.create(name: 'test_category')
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1', category_ids: category.id, created_at: 1.day.ago)
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2', category_ids: category.id, created_at: 2.days.ago)
      vid_3 = Video.create(title: 'test_video_3', description: 'test_description_3', category_ids: category.id, created_at: 3.days.ago)
      vid_4 = Video.create(title: 'test_video_4', description: 'test_description_4', category_ids: category.id, created_at: 4.days.ago)
      vid_5 = Video.create(title: 'test_video_5', description: 'test_description_5', category_ids: category.id, created_at: 5.days.ago)
      vid_6 = Video.create(title: 'test_video_6', description: 'test_description_6', category_ids: category.id, created_at: 6.days.ago)
      vid_7 = Video.create(title: 'test_video_7', description: 'test_description_7', category_ids: category.id, created_at: 7.days.ago)

      expect(category.recent_videos.count).to eq(6)
    end

    it 'returns the most recent 6 videos' do
      category = Category.create(name: 'test_category')
      vid_1 = Video.create(title: 'test_video_1', description: 'test_description_1', category_ids: category.id, created_at: 1.day.ago)
      vid_2 = Video.create(title: 'test_video_2', description: 'test_description_2', category_ids: category.id, created_at: 2.days.ago)
      vid_3 = Video.create(title: 'test_video_3', description: 'test_description_3', category_ids: category.id, created_at: 3.days.ago)
      vid_4 = Video.create(title: 'test_video_4', description: 'test_description_4', category_ids: category.id, created_at: 4.days.ago)
      vid_5 = Video.create(title: 'test_video_5', description: 'test_description_5', category_ids: category.id, created_at: 5.days.ago)
      vid_6 = Video.create(title: 'test_video_6', description: 'test_description_6', category_ids: category.id, created_at: 6.days.ago)
      vid_7 = Video.create(title: 'test_video_7', description: 'test_description_7', category_ids: category.id, created_at: 7.days.ago)

      expect(category.recent_videos).to eq([vid_1, vid_2, vid_3, vid_4, vid_5, vid_6])
    end

    it 'returns an empty array if the category does not have any videos' do
      category = Category.create(name: 'test_category')

      expect(category.recent_videos).to eq([])
    end
  end
end