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
  has_many :user_attributes
  has_many :program_attributes, through: :user_attributes
  has_one_attached :avatar  # This is for the Active Storage association for the user's avatar.
end
