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

  has_one_attached :avatar  # This is for the Active Storage association for the user's avatar.

  enum gender: { Masculino: 0, Feminino: 1 }
  enum country: { Portugal: 0 }
  enum city: { Lisboa: 0 }

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
end
