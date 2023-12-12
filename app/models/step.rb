class Step < ApplicationRecord
  belongs_to :program
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :posts
  has_many :step_questions, dependent: :destroy
  has_one_attached :image
  has_many :step_question_options, through: :step_questions
  has_many :user_answers, through: :step_question_options

  has_rich_text :description
  
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

  def gender_distribution
    total_users = users.count
    return {} if total_users.zero?

    genders = { 'Masculino' => 0, 'Feminino' => 1, 'Outro' => 2 }
    genders.each_with_object({}) do |(key, value), distribution|
      count = users.where(gender: value).count
      distribution[key] = (count.to_f / total_users * 100).round(2)
    end
  end

  def age_distribution
    age_ranges = {
      '18-25' => 0,
      '26-30' => 0,
      '31-35' => 0,
      '36-40' => 0,
      '41-50' => 0,
      '50+' => 0
    }

    users.each do |user|
      user_age = user.age
      next unless user_age # Skip if user_age is nil

      case user_age
      when 18..25 then age_ranges['18-25'] += 1
      when 26..30 then age_ranges['26-30'] += 1
      when 31..35 then age_ranges['31-35'] += 1
      when 36..40 then age_ranges['36-40'] += 1
      when 41..50 then age_ranges['41-50'] += 1
      else age_ranges['50+'] += 1 if user_age > 50
      end
    end

    total_users = users.count
    return {} if total_users.zero?

    age_ranges.transform_values { |count| (count.to_f / total_users * 100).round(2) }
  end

  def calculate_total_questionnaire(user_id)
    user = User.find(user_id)
    total = 0
    if user
      user.user_answers.includes(:step_question_option)
          .filter { |user_answer| user_answer.step_question_option.step_question.step_id == self.id }
          .each do |user_answer|
        answer_custom_weight = user_answer.custom_weight != nil
        answer_weight = answer_custom_weight ? user_answer.custom_weight : user_answer.step_question_option.weight
        total += answer_weight
      end
    end
    total
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
