class Organization < ActiveRecord::Base
  PROCESSING_FEES = {pass: 0, absorb: 1, split: 2, decide: 3}
  enum processing_fees: PROCESSING_FEES

  has_many :users
  has_many :events
  has_many :purchased_tickets, through: :events
  has_many :todos
  has_many :organizers
  has_many :orders
  accepts_nested_attributes_for :organizers

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates_associated :organizers

  mount_uploader :logo, LogoUploader
  mount_uploader :cover_photo, CoverPhotoUploader

  store_accessor :settings, 
    :redirect_url, :require_customer_id, :keep_events_private,
    :authorize_net_id, :authorize_net_key

  attr_accessor :cover_photo_upload_width, :cover_photo_upload_height

  validate :check_cover_photo_dimensions

  def require_customer_id?
    require_customer_id == '1'
  end

  def keep_events_private?
    keep_events_private == '1'
  end

  def account_owner
    organizers.where(id: self.account_owner_id).first
  end

  private

  def check_cover_photo_dimensions
    if self.cover_photo_upload_width && (self.cover_photo_upload_width < 1280 || self.cover_photo_upload_height < 360)
      errors.add :cover_photo, "Dimensions of uploaded cover photo should be not less than 1280x360 pixels."
    end
  end

end
