class Step < ApplicationRecord
  belongs_to :program
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :posts
  has_many :step_questions

  validate :dates_must_be_present_and_valid

  def name_with_order
    "Step #{step_order} - #{name}"
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
