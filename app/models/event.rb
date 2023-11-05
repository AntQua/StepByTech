class Event < ApplicationRecord
  belongs_to :user, optional: true
  has_many :users_events
  has_many :users, through: :users_events
  has_many :posts
  belongs_to :program, optional: true
  belongs_to :step, optional: true
  has_one_attached :image

  enum status: { agendado: 0, terminado: 1 }
  enum event_type: { online: 0, presencial: 1 }
end
