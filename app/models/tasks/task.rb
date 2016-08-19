class Task < ActiveRecord::Base
  belongs_to :customer
  has_many :checks

  def total_checks
    self.checks.where(flag: true).length
  end
end
