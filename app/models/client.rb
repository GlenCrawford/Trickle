class Client < ActiveRecord::Base
  has_many :projects

  before_save :cap_code

  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code, :message => "is already in use by another client"

  private

  def cap_code
    self.code = self.code.upcase
  end
end