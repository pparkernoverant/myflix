class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by(slug: queue_item_params[:video_id])

    if current_user_queued_video?(video)
      flash[:error] = 'That item is already in your queue.'
    else
      @queue_item = QueueItem.create(video: video, user: current_user, position: new_queue_item_position )
      if @queue_item.save
        flash[:notice] = 'Item added to your queue.'
      else
        flash[:error] = 'There was an error adding that item to your queue.'
      end
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by(id: queue_item_params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

  private

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def queue_item_params
    params.permit(:video_id, :id)
  end
end