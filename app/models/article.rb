class Article < ApplicationRecord
    default_scope -> {order(created_at: :desc)}
    belongs_to :user
    validates :user_id, presence: true
    validates :title, presence: true
    validates :content, presence: true
end
