class Organization < ActiveRecord::Base
  has_many :users
  has_many :organizers
  has_many :locations
  has_many :products
  has_many :plans
  accepts_nested_attributes_for :organizers

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates_associated :organizers

  mount_uploader :logo, LogoUploader
  mount_uploader :cover_photo, CoverPhotoUploader

  store_accessor :settings, 
    :customer_service_email, :customer_service_phone, :refund_policy, :recurly_subdomain,
    :recurly_private_key, :recurly_public_key, :address_requirement, :shipping_notification_email

  attr_accessor :cover_photo_upload_width, :cover_photo_upload_height

  def account_owner
    organizers.where(id: self.account_owner_id).first
  end

end
