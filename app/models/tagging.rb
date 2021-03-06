class Tagging < ActiveRecord::Base
  validates :membership_id, uniqueness: {scope: :tag_id} # prevent duplicate taggings
  belongs_to :membership
  belongs_to :tag
end
