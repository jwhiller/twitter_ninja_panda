class Tweet < ApplicationRecord

belongs_to :user
has_many :tweet_tags
has_many :tags, through: :tweet_tags

validates :message, presence: true, length: {maximum: 110, too_long: "You have hit your word cap!"}

end
