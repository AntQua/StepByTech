class Event < ApplicationRecord
  belongs_to :user
  has_many :users_events
  has_many :users, through: :users_events

  belongs_to :program, optional: true
  belongs_to :step, optional: true
end
