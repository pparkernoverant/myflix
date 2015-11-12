require 'spec_helper'

feature 'User interacts with the queue' do
  scenario 'user adds and reorders videos in their queue' do
    category = Fabricate(:category)
    video_1 = Fabricate(:video, title: 'video_1', categories: [category])
    video_2 = Fabricate(:video, title: 'video_2', categories: [category])
    video_3 = Fabricate(:video, title: 'video_3', categories: [category])

    sign_in
    find("a[href='/videos/#{video_1.slug}']").click
    page.should have_content video_1.title

    click_link '+ My Queue'
    page.should have_content video_1.title

    visit video_path(video_1)
    page.should_not have_content '+ My Queue'

    add_video_to_my_queue(video_2)
    add_video_to_my_queue(video_3)

    set_video_position_in_queue(video_1, 3)
    set_video_position_in_queue(video_2, 1)
    set_video_position_in_queue(video_3, 2)

    click_button 'Update Instant Queue'

    expect_video_position_in_queue(video_1, 3)
    expect_video_position_in_queue(video_2, 1)
    expect_video_position_in_queue(video_3, 2)
  end

  def add_video_to_my_queue(video)
    visit home_path
    find("a[href='/videos/#{video.slug}']").click
    click_link '+ My Queue'
  end

  def expect_video_position_in_queue(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

  def set_video_position_in_queue(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") { fill_in 'queue_items[][position]', with: position.to_s }
  end
end