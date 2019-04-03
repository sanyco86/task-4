# == Schema Information
#
# Table name: buses
#
#  id     :bigint(8)        not null, primary key
#  number :string
#  model  :string
#

class Bus < ApplicationRecord
  MODELS = %w(Икарус Мерседес Сканиа Буханка УАЗ Спринтер ГАЗ ПАЗ Вольво Газель).freeze

  has_many :trips
  has_and_belongs_to_many :services, join_table: :buses_services

  validates :number, presence: true, uniqueness: true
  validates :model, inclusion: { in: MODELS }
end
