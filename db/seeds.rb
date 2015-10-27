# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.all.each {|x| x.destroy }
Video.all.each {|x| x.destroy }

Category.create(name: 'Comedy')
Category.create(name: 'Drama')

Video.create(title: 'Wizard People, Dear Reader', description: 'Wizard People, Dear Reader is a narrative retelling of the lives of the characters of The Sorcerers Stone and the world in which they live. Presented in the form of a thirty-five chapter audiobook, this soundtrack is intended to replace the films audio track.', small_cover_url: '/tmp/wizard_people_dear_reader.jpg', large_cover_url: '/tmp/wizard_people_dear_reader.jpg', category_ids: Category.where(name: 'Comedy').first.id)
Video.create(title: 'Waking Life', description: 'The film explores a wide range of philosophical issues including the nature of reality, dreams, consciousness, the meaning of life, free will, and existentialism. Waking Life is centered on a young man who wanders through a variety of dream-like realities wherein he encounters numerous individuals who willingly engage in insightful philosophical discussions.', small_cover_url: '/tmp/waking_life.jpg', large_cover_url: '/tmp/waking_life.jpg', category_ids: Category.where(name: 'Drama').first.id)
Video.create(title: 'The Blues Brothers', description: 'The story is a tale of redemption for paroled convict Jake and his brother Elwood, who take on "a mission from God" to save from foreclosure the Catholic orphanage in which they grew up. To do so, they must reunite their R&B band and organize a performance to earn $5,000 needed to pay the orphanages property tax bill.', small_cover_url: '/tmp/the_blues_brothers.jpg', large_cover_url: '/tmp/the_blues_brothers.jpg', category_ids: Category.where(name: 'Comedy').first.id)
  