class UserAttribute < ApplicationRecord
  belongs_to :program_attribute
  belongs_to :user
end
