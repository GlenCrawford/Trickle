class Settings < ActiveRecord::Base
  validate :validate_positives

  validates_presence_of :daily_resource_amount, :company_code, :company_name, :low_utilization_level, :high_utilization_level
  validates_numericality_of :daily_resource_amount, :low_utilization_level, :high_utilization_level, :only_integer => true, :message => "must be a whole number"

  def self.get
    Settings.first
  end

  protected

  def validate_positives
    errors.add(:daily_resource_amount, "must be greater than zero") if daily_resource_amount.present? && daily_resource_amount <= 0
    errors.add(:low_utilization_level, "must be greater than zero") if low_utilization_level.present? && low_utilization_level <= 0
    errors.add(:high_utilization_level, "must be greater than zero") if high_utilization_level.present? && high_utilization_level <= 0
  end
end