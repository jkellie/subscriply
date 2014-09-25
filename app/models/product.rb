class Product < ActiveRecord::Base
  belongs_to :organizatio
  has_many :plans

  def plans_count
    plans.count
  end

  def deletable?
    plans_count == 0
  end
end