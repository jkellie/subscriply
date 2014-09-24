class Product < ActiveRecord::Base
  belongs_to :organization

  def plans_count
    # TODO: Implement when plans become a thing
    5
  end

  def deletable?
    # TODO: Implement when plans become a thing
    true
  end
end