require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(assigns(:video)).to eq(video)
    end

    it 'sets @reviews for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review_1 = Fabricate(:review, video: video)
      review_2 = Fabricate(:review, video: video)
      get :show, id: video.slug
      expect(assigns(:reviews)).to match_array([review_1, review_2])
    end

    it 'redirects user to the sign in page for unauthenticated users' do
      video = Fabricate(:video)
      get :show, id: video.slug
      expect(assigns(:video)).to redirect_to sign_in_path
    end
  end

  describe 'POST search' do
    it 'sets @results for authenticaed users' do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end

    it 'redirects tp sign in page for unauthenticated users' do
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search_term: 'rama'
      expect(response).to redirect_to sign_in_path
    end
  end
end