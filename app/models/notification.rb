class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifications_config
end
