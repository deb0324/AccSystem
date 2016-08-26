class Customer < ActiveRecord::Base
  belongs_to :officer, foreign_key: :officer_id, class_name: 'User'
  belongs_to :leader, foreign_key: :leader_id, class_name: 'User'
  belongs_to :manager, foreign_key: :manager_id, class_name: 'User'

  has_many :tasks

  validates :code, presence: {message: "請填寫客戶代號"}
  validates :name_abrev, presence: {message: "請填寫客戶簡稱"}
end
