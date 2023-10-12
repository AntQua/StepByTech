class ProgramAttribute < ApplicationRecord
  belongs_to :program
  has_many :user_attributes
  has_many :users, through: :user_attributes
end
