class TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  before_save :add_created_at
  before_save :set_note
  before_validation :calc_time_spent
  before_validation :calc_extra_time

  validates_presence_of :user_id, :task_id, :time_spent
  validates_presence_of :extra_time, :if => :extra_time_present
  validates_numericality_of :time_spent, :only_integer => true, :greater_than => 0
  validates_numericality_of :extra_time, :only_integer => true, :greater_than_or_equal_to => 0, :if => :extra_time_present

  attr_accessor :time_spent_hours, :time_spent_minutes, :extra_time_hours, :extra_time_minutes

  def extra_time_present
    extra_time.present?
  end

  def calc_time_spent
    self.time_spent = (time_spent_hours.to_i * 60) + time_spent_minutes.to_i
  end

  def calc_extra_time
    self.extra_time = (extra_time_hours.to_i * 60) + extra_time_minutes.to_i
  end

  def add_created_at
    created_at = Time.now
  end

  def set_note
    note ||= ''
  end
end