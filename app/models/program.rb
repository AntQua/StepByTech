class Program < ApplicationRecord
  has_many :steps, dependent: :destroy
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :program_attributes
  has_many :events
  has_many :posts
  has_many :step_questions, through: :steps
  has_many :step_question_options, through: :step_questions
  validates :registration_limit, numericality: { only_integer: true }

  has_one_attached :image # This is for the Active Storage association for the user's avatar.

  def registration_open?
    current_date = Date.today
    current_date >= registration_start_date && current_date <= registration_end_date
  end

  def is_candidate?(user_id)
    users.exists?(id: user_id)
  end

  def next_step_name(current_step_order)
    next_step = next_step(current_step_order)
    next_step != nil ? next_step.name : ""
  end

  def next_step(current_step_order)
    steps.find_by(step_order: current_step_order + 1)
  end

  def check_apply_available?(user)
    registration_open? && !user.is_admin && is_candidate?(user.id) == false
  end

  # Verifica se um usuário já está candidato ao programa, se ele está aprovado no step atual
  # em que se encontra, se o step atual possui datas, e se a data atual é igual ou ultrapassa
  # a última data desse step. Além disso, verifica se o usuário já preencheu o questionário
  # existente no step atual.
  def check_pending_questionnaires?(user)
    return false if user.is_admin

    user_program_step = user.users_programs_steps.find_by(program_id: id)
    current_step = user_program_step&.step

    if user_program_step&.status == UsersProgramsStep.statuses.key(1) &&
      current_step&.dates&.max.to_date <= Date.today &&
      !user.answered_step?(current_step&.id)

      return step_questions.exists?(step_id: current_step.id)
    end

    false
  end

  def user_count
    users.count
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
      '50+'   => 0
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
      else age_ranges['50+']   += 1 if user_age > 50
      end
    end

    total_users = users.count
    return {} if total_users.zero?

    age_ranges.transform_values { |count| (count.to_f / total_users * 100).round(2) }
  end



  # Scopes
  scope :active, -> { where(active: true) }

end
