class Plan < ActiveRecord::Base
  belongs_to :organization
  belongs_to :product

  def permalink
    "#{product.prepend_code}_#{self.code}"
  end

  def deletable?
    false
  end

  def trial?
    self.free_trial_length > 0
  end
end