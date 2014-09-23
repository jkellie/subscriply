class Location < ActiveRecord::Base
  belongs_to :organization

  validates :name, :street_address, :city, :state, :zip, presence: true
end