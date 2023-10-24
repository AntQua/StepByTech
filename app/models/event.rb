class Event < ApplicationRecord
  belongs_to :user
  has_many :users_events
  has_many :users, through: :users_events
  belongs_to :program, optional: true
  belongs_to :step, optional: true

  enum status: { scheduled: 0, closed: 1 }
  enum event_type: { online: 0, in_person: 1 }
end

