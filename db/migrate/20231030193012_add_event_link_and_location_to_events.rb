class AddEventLinkAndLocationToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :event_link, :string
    add_column :events, :event_location, :string
  end
end
