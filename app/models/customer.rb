class Customer < ActiveRecord::Base
  belongs_to :officer, foreign_key: :officer_id, class_name: 'User'
  belongs_to :leader, foreign_key: :leader_id, class_name: 'User'
  belongs_to :manager, foreign_key: :manager_id, class_name: 'User'

  has_many :tasks

  validates :name, presence: true 
  #validates :officer_id, :manager_id, :leader_id,  presence: true
end
