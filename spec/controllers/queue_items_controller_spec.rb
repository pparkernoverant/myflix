require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items to the queue items of the logged in user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item_1 = Fabricate(:queue_item, user: alice)
      queue_item_2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item_1, queue_item_2])
    end

    it 'redirects to the sign in page for unauthenticated users' do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'POST create' do
    context 'with authenticated user' do
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }

      it 'redirects to the my queue page' do
        post :create, video_id: video.slug
        expect(response).to redirect_to my_queue_path
      end

      it 'creates a queue item' do
        post :create, video_id: video.slug
        expect(QueueItem.count).to eq(1)
      end

      it 'creates the queue item that is associated with the video' do
        post :create, video_id: video.slug
        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates the queue item that is associated with the signed in user' do
        post :create, video_id: video.slug
        expect(QueueItem.first.user).to eq(user)
      end

      it 'puts the video as the last one in the queue' do
        Fabricate(:queue_item, video: video, user: user)
        video_2 = Fabricate(:video)
        post :create, video_id: video_2.slug
        video_2_queue_item = QueueItem.find_by(video_id: video_2.id)
        expect(video_2_queue_item.position).to eq(2)
      end

      it 'does not add the video to the queue if the video is already in the queue' do
        Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.slug
        expect(user.queue_items.count).to eq(1)
      end
    end

    context 'with unauthenticated user' do
      it 'redirects to the sign in page for unauthenticated users' do
        post :create, video_id: 3
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }

      it 'redirects to the my queue page' do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it 'deletes the queue item' do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it 'does not delete the queue item if the queue item is not in the current users queue' do
        user_2 = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: user_2)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context 'with unauthenticated user' do
      it 'redirects to the sign in page for unauthenticated users' do
        delete :destroy, id: 3
        expect(response).to redirect_to sign_in_path
      end
    end


  end
end