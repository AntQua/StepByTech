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

  # Scopes
  scope :for_programs, -> { where.not(program_id: nil) }
  scope :for_steps, -> { where.not(step_id: nil) }
  scope :for_events, -> { where.not(event_id: nil) }
  scope :general, -> { where(program_id: nil, event_id: nil) }

  # Custom methods (if any)

  # For example, if you want to check if a post is related to a program
  def related_to_program?
    program_id.present?
  end

  # For example, if you want to check if a post is related to a step
  def related_to_step?
    step_id.present?
  end

  # Or if you want to check if a post is related to an event
  def related_to_event?
    event_id.present?
  end

  # This method might be used to retrieve all related comments, files, etc.
  def related_items
    # Implement logic to gather related items if needed
  end

end
