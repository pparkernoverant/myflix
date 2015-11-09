require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video, title: 'test_title')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('test_title')
    end
  end

  describe '#rating' do
    it 'returns the rating from the review when the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it 'returns nul when the review is not present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#category_names' do
    it 'returns the category names of the video' do
      category_1 = Fabricate(:category, name: 'test_category_1')
      category_2 = Fabricate(:category, name: 'test_category_2')
      video = Fabricate(:video, categories: [category_1, category_2])
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_names).to match_array ['test_category_1', 'test_category_2']
    end
  end

  describe '#categories' do
    it 'returns the categories of the video' do
      category_1 = Fabricate(:category, name: 'test_category_1')
      category_2 = Fabricate(:category, name: 'test_category_2')
      video = Fabricate(:video, categories: [category_1, category_2])
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.categories).to match_array [category_1, category_2]
    end
  end

end