# == Schema Information
#
# Table name: trips
#
#  id               :bigint(8)        not null, primary key
#  from_id          :integer
#  to_id            :integer
#  start_time       :string
#  duration_minutes :integer
#  price_cents      :integer
#  bus_id           :integer
#

class Trip < ApplicationRecord
  HHMM_REGEXP = /([0-1][0-9]|[2][0-3]):[0-5][0-9]/.freeze

  belongs_to :from, class_name: 'City'
  belongs_to :to,   class_name: 'City'
  belongs_to :bus

  validates :start_time, format: { with: HHMM_REGEXP, message: 'Invalid time' }
  validates :duration_minutes, :price_cents, numericality: { greater_than: 0 }

  def to_h
    {
      bus: {
        model: bus.model,
        number: bus.number,
        services: bus.services.map(&:name),
      },
      duration_minutes: duration_minutes,
      from: from.name,
      price_cents: price_cents,
      start_time: start_time,
      to: to.name
    }
  end
end
