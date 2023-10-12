class Event < ApplicationRecord
  belongs_to :user
  has_many :users_events
  has_many :users, through: :users_events
end
