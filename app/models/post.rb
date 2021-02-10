class Post < ApplicationRecord

  validates :title, presence: true, uniqueness: true
  # with: /\A[a-zA-Z]+\z/
  # format: { }
  validates :happy, presence: true
  # validates :scale, presence: true
  # has_rich_text :title
  has_many :kids, class_name: "Comment", primary_key: 'hn_id', foreign_key: 'parent_id'
  accepts_nested_attributes_for :kids, allow_destroy: true

  after_create_commit {broadcast_prepend_to "posts"}
  after_update_commit {broadcast_replace_to "posts"}
  after_destroy_commit {broadcast_remove_to "posts"}
end
