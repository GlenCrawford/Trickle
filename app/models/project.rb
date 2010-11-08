class Project < ActiveRecord::Base
  belongs_to :client
  has_many :tasks, :dependent => :destroy, :order => "number ASC"
  has_and_belongs_to_many :users

  before_create :add_created_data
  before_create :add_status
  before_save :add_updated_data
  before_save :generate_number
  before_destroy :remove_projects_users_association

  validate :check_budget

  def generate_number
    if Project.count == 0
      self.number = 1
    else
      self.number ||= Project.last.number.to_i + 1
    end
  end

  # Note that these validations are inherited by child models (along with
  # everything else)
  validates_presence_of :client_id, :type, :name, :budget
  validates_uniqueness_of :name, :number
  validates_numericality_of :client_id, :budget, :only_integer => true
  validates_numericality_of :estimate_id, :only_integer => true, :if => :estimate_id_present?
  validates_numericality_of :owner_id, :only_integer => true, :if => :owner_id_present?

  # Resolve relationships
  def creator
    User.find creator_id
  end

  def updater
    User.find updater_id
  end

  def estimate
    begin
      @estimate = Estimate.find estimate_id
    rescue ActiveRecord::RecordNotFound
      @estimate = nil
    end
    @estimate
  end

  def estimate_id_present?
    self.estimate_id.present?
  end

  def owner_id_present?
    self.owner_id.present?
  end

  def is_estimate?
    self.type == "Estimate"
  end

  def is_job?
    self.type == "Job"
  end

  def order_tasks
    new_number = 0
    self.tasks.each do |task|
      new_number += 1
      task.number = new_number
      task.save
    end
  end

  def add_status
    self.status = "open"
  end

  def add_created_data
    self.created_at = Time.now
    self.creator_id = User.current.id
  end

  def add_updated_data
    self.updated_at = Time.now
    self.updater_id = User.current.id
  end

  def check_budget
    errors.add(:budget, "must be greater than zero") if budget.present? && budget <= 0
  end

  def remove_projects_users_association
    self.users.clear
  end
end