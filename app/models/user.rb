class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :users_programs_steps
  has_many :programs, through: :users_programs_steps
  has_many :users_events
  has_many :events, through: :users_events
  has_many :notifications
  has_many :posts
  has_many :user_answers

  # Add fields for data protection responses
  attribute :data_protection_usage, :boolean, default: false
  attribute :data_protection_divulgation, :boolean, default: false
  attribute :data_protection_evaluation, :boolean, default: false
  attribute :data_protection_terms, :boolean, default: false

  validate :at_least_18

  has_one_attached :avatar  # This is for the Active Storage association for the user's avatar.

  enum gender: { Masculino: 0, Feminino: 1, Outro: 2 }
  enum country: { Portugal: 0 }
  enum city: { Lisboa: 0 }

  # calculate age from the birth date
  def age
    return unless birth_date
    now = Time.zone.now.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end

  def answered_step?(step_id)
    user_answers.joins(step_question_option: { step_question: :step })
                .where(steps: { id: step_id })
                .exists?
  end

  def user_program_step(program)
    users_programs_steps.find_by(program: program)
  end

  def current_step(program)
    user_program_step(program)&.step
  end

  private

  def at_least_18
    return if birth_date.blank?
    errors.add(:birth_date, 'Você deve ter pelo menos 18 anos de idade.') if age < 18
  end
end
