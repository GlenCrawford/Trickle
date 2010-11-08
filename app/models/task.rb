class Task < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :users
  belongs_to :resource_type
  has_many :time_entries, :dependent => :destroy
  #has_many :users, :through => :time_entries

  before_create :add_status
  before_create :add_number
  before_validation :calc_unit_cost
  before_destroy :remove_tasks_users_association

  validates_presence_of :name, :project_id
  validates_presence_of :resource_type_id, :quantity, :unit_cost, :if => :is_estimate?
  validates_presence_of :budget, :if => :is_job?

  validates_inclusion_of :billable, :in => [true, false]

  validates_numericality_of :quantity, :only_integer => true, :if => :is_estimate?
  validates_numericality_of :unit_cost, :if => :is_estimate?
  validates_numericality_of :budget, :only_integer => true, :if => :is_job?

  validate :check_positive_numbers

  def time_spent
    time_spent_count = 0
    time_entries.each do |time_entry|
      time_spent_count += time_entry.time_spent
    end
    time_spent_count
  end

  def total_extra_times
    total_extra_time_count = 0
    time_entries.each do |time_entry|
      total_extra_time_count += time_entry.extra_time
    end
    total_extra_time_count
  end

  protected

  def is_job?
    my_project.is_job?
  end

  def is_estimate?
    my_project.is_estimate?
  end

  def my_project
    Project.find project_id
  end

  def my_resource_type
    begin
      ResourceType.find resource_type_id
    rescue ActiveRecord::RecordNotFound
      #
    end
  end

  def add_status
    self.status ||= "open"
  end

  def add_number
    self.number ||= my_project.tasks.count + 1
  end

  def calc_unit_cost
    self.unit_cost = quantity * my_resource_type.rate if my_resource_type != nil
  end

  def check_positive_numbers
    errors.add(:budget, "must be greater than zero") if budget.present? && budget <= 0
    errors.add(:quantity, "must be greater than zero") if quantity.present? && quantity <= 0
    errors.add(:unit_cost, "must be greater than zero") if unit_cost.present? && unit_cost <= 0
  end

  def remove_tasks_users_association
    users.clear
  end
end