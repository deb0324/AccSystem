class Customer < ActiveRecord::Base
  belongs_to :officer, foreign_key: :officer_id, class_name: 'User'
  belongs_to :leader, foreign_key: :leader_id, class_name: 'User'
  belongs_to :manager, foreign_key: :manager_id, class_name: 'User'

  has_many :tasks

  validates :code, presence: {message: "請填寫客戶代號"}
  validates :name_abrev, presence: {message: "請填寫客戶簡稱"}
  validates :name, presence: {message: "請填寫客戶全名"}
  validates :reg_addr, presence: {message: "請填寫登記地址"}
  validates :contact_addr, presence: {message: "請填寫聯絡地址"}
  validates :contact, presence: {message: "請填寫聯絡人"}
  validates :cellphone, presence: {message: "請填寫手機"}
  validates :phone, presence: {message: "請填寫電話"}
  validates :fax, presence: {message: "請填寫傳真"}
  validates :email, presence: {message: "請填寫信箱"}
  validates :fee, presence: {message: "請填寫費用"}
  validates :start_date, presence: {message: "請填寫起始年月 (yyyy-mm-dd)"}
end
