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

      it 'normalizes the remaining queue items' do
        queue_item_1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item_2 = Fabricate(:queue_item, user: user, position: 2)
        delete :destroy, id: queue_item_1.id
        expect(queue_item_2.reload.position).to eq(1)
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

  describe 'POST update_queue' do
    let!(:user) { Fabricate(:user) }
    let!(:queue_item_1) { Fabricate(:queue_item, user: user, position: 1) }
    let!(:queue_item_2) { Fabricate(:queue_item, user: user, position: 2) }

    context 'with authenticated users' do
      before { session[:user_id] = user.id }

      context 'with valid inputs' do
        it 'redirects to the my queue page' do
          post :update_queue, queue_items: [{id: queue_item_1.id, position: 2}, {id: queue_item_2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it 'reorders the queue items' do
          post :update_queue, queue_items: [{id: queue_item_1.id, position: 2}, {id: queue_item_2.id, position: 1}]
          expect(user.queue_items).to eq([queue_item_2, queue_item_1])
        end

        it 'normalizes the position numbers' do
          post :update_queue, queue_items: [{id: queue_item_1.id, position: 3}, {id: queue_item_2.id, position: 1}]
          expect(user.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context 'with invalid inputs' do
        before { post :update_queue, queue_items: [{id: queue_item_1.id, position: 3}, {id: queue_item_2.id, position: 2.1}] }

        it 'redirects to the my queue page' do
          expect(response).to redirect_to my_queue_path
        end

        it 'sets the flash error message' do
          expect(flash[:error]).to be_present
        end

        it 'does not change the queue items' do
          expect(queue_item_1.reload.position).to eq(1)
          expect(queue_item_2.reload.position).to eq(2)
        end
      end

      context 'with queue items that do not belong to the current user' do
        it 'does not change the items' do
          user_2 = Fabricate(:user)
          queue_item_3 = Fabricate(:queue_item, user: user_2, position: 1)
          post :update_queue, queue_items: [{id: queue_item_2.id, position: 2}, {id: queue_item_3.id, position: 2}]

          expect(queue_item_3.reload.position).to eq(1)
        end
      end
    end

    context 'with unauthenticated users' do
      it 'redirects do the sign in path' do
        post :update_queue, queue_items: [{id: queue_item_1.id, position: 2}, {id: queue_item_2.id, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end

  end

end