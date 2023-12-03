class Step < ApplicationRecord
  belongs_to :program
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :posts
  has_many :step_questions, dependent: :destroy
  has_one_attached :image
  has_many :user_answers

  validate :dates_must_be_present_and_valid

  def name_with_order
    "Step #{step_order} - #{name}"
  end

  # Scopes
  scope :active, -> { where(active: true) }

  def user_count
    users.count
  end

  def submissions_count
    users_programs_steps.joins(:users_programs_steps_submissions).count
  end


  private

  def dates_must_be_present_and_valid
    dates.reject!(&:blank?)
    if dates.blank?
      errors.add(:dates, "must be present")
    else
      dates.each do |date|
        unless date.is_a?(Date)
          errors.add(:dates, "must contain valid date values")
        end
      end
    end
  end

  # def clean_dates
  #   self.dates = dates.reject(&:blank?)
  # end
end
