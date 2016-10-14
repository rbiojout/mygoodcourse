# == Schema Information
#
# Table name: peers
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_peers_on_followed_id                  (followed_id)
#  index_peers_on_followed_id_and_follower_id  (followed_id,follower_id) UNIQUE
#  index_peers_on_follower_id                  (follower_id)
#

class Peer < ActiveRecord::Base
  belongs_to :follower, class_name: "Customer", foreign_key: "follower_id"
  belongs_to :followed, class_name: "Customer", foreign_key: "followed_id"

  validates :follower, presence: true
  validates :followed, presence: true

end
