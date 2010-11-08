class ResourceType < ActiveRecord::Base
  has_many :tasks

  validates_presence_of :code, :name, :rate
  validates_uniqueness_of :code, :name
  validates_numericality_of :rate, :greater_than => 0
end