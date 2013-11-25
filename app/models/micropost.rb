class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope order: 'microposts.created_at DESC'
  # alternatively *note* these are rails 3.2 compatible, different for rails 4.0+
  # default_scope order("created_at DESC")
end
