class Task < ActiveRecord::Base
  belongs_to :customer
  has_many :checks
  #belongs_to :check

  def total_verifications
    self.verifications.where(flag: true).length
  end
end
