class VideosController < ApplicationController
  def index
  end

  def show
    @video = Video.find_by slug: params[:id]
  end
end