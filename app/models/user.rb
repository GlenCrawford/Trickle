class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable

  belongs_to :role
  has_many :activities, :dependent => :destroy
  has_and_belongs_to_many :tasks
  has_and_belongs_to_many :projects
  has_many :time_entries
  #has_many :tasks, :through => :time_entries

  before_destroy :remove_tasks_users_association
  before_destroy :remove_projects_users_association

  attr_accessible :first_name, :last_name, :nick_name, :email, :username,
                  :telephone_number, :mobile_number, :password,
                  :password_confirmation, :remember_me, :avatar, :role_id

  validates_presence_of :first_name, :last_name, :nick_name, :username, :role_id, :email, :telephone_number, :mobile_number, :avatar, :password
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :email, :maximum => 50
  validates_length_of :password, :minimum => 8, :if => :password_sent?
  validates_uniqueness_of :nick_name, :email, :username, :mobile_number, :message => "has already been taken by another user"

  # Downcase whatever the user typed in as the username. Glen == glen
  def self.find_for_authentication(params)
    params[:username].downcase!
    super params
  end

  def name
    self.first_name + " " + self.last_name
  end

  def self.current
    # Allows other models to access the current user via User.current
    Thread.current[:user]
  end

  def has_admin_rights
    self.role.id == Role.find_by_name("Administrator").id
  end

  def has_project_manager_rights
    self.has_admin_rights || self.role.id == Role.find_by_name("Project manager").id
  end

  def has_team_leader_rights
    self.has_admin_rights || self.role.id == Role.find_by_name("Team leader").id
  end

  protected

  def password_sent?
    self.password.present?
  end

  def remove_tasks_users_association
    tasks.clear
  end

  def remove_projects_users_association
    projects.clear
  end
end