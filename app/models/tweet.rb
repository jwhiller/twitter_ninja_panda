class Tweet < ApplicationRecord

belongs_to :user
validates :message, presence: true, length: {maximum: 110, too_long: "You have hit your word cap!"}

end
