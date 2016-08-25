class User < ActiveRecord::Base
  has_many :customers

  has_secure_password

  validates :code, :name, :password, presence: true
  
  def accountant?
    self.code == "Y01" || self.code == "Y02"
  end

  def permission?(task, check)
    if self.id == Customer.find(task.customer_id).officer_id && !(self.id == Customer.find(task.customer_id).leader_id || self.id == Customer.find(task.customer_id).manager_id)
      (check.type == "Recieved" || check.type == "Primary")
    else
      if check.type == "Accountant"
        self.accountant?
      else
        true
      end
    end
  end

  def completed?(task, check)
    case check.type
    when "Recieved"
      true
    when "Primary"
      task.checks.where(type: "Recieved").first.flag
    when "Secondary"
      task.checks.where(type: "Primary").first.flag
    when "Accountant"
      task.checks.where(type: "Secondary").first.flag
    when "Upload"
      if task.type == "IncomeTax"
        task.checks.where(type: "Accountant").first.flag
      else
        task.checks.where(type: "Secondary").first.flag
      end
    else
      false
    end
  end
end
