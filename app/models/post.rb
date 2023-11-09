class Post < ApplicationRecord
  belongs_to :user
  belongs_to :program, optional: true
  belongs_to :step, optional: true
  belongs_to :event, optional: true


  has_many_attached :media_contents # This will handle both images and videos

  validates :title, presence: true
  validates :body, presence: true

  # Virtual attribute for handling the association type in form
  attr_accessor :association_type
  # Virtual attribute for program_id when associating with a step
  attr_accessor :program_id_for_step

  # Scopes
  scope :for_association_type, ->(association_type) {
    case association_type
    when 'event'
      where.not(event_id: nil)
    when 'program'
      where.not(program_id: nil)
    when 'step'
      where.not(step_id: nil)
    when 'none'
      where(event_id: nil, program_id: nil, step_id: nil)
    end
  }

end
