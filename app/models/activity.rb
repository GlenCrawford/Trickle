class Activity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :thing_id, :thing_type, :action, :action_date

  def self.create(new_thing_id, new_thing_type, new_action)
    @new_activity = Activity.new

    @new_activity.user_id = User.current.id
    @new_activity.thing_id = new_thing_id
    @new_activity.thing_type = new_thing_type
    @new_activity.action = new_action
    @new_activity.action_date = Time.now

    @new_activity.save
  end

  def print
    case self.thing_type
      when "user", "client", "estimate", "job"
        if self.action.include? '?'
          action_array = self.action.split('?')
          self.action = action_array[0]
          message = "#{self.action_printable} #{self.thing_type} '#{action_array[1]}'"
        else
          message = "#{self.action_printable} "
          begin
            message += "#{self.thing_type} '#{self.thing.name}'"
          rescue ActiveRecord::RecordNotFound
            message += "a #{self.thing_type}, which no longer exists"
          end
        end
      when "settings"
        message = "#{self.action_printable} settings for Trickle"
      when "time_entry"
        message = "Added #{TimeEntry.find(self.thing_id).time_spent} minutes to task '#{Task.find(TimeEntry.find(self.thing_id).task_id).name}'"
        self.action = "deleted"
    end
    message
  end

  protected

  def action_printable
    self.action.capitalize
  end

  def thing
    case self.thing_type
      when "user"
        @thing = User.find(self.thing_id)
      when "client"
        @thing = Client.find(self.thing_id)
      when "estimate"
        @thing = Estimate.find(self.thing_id)
      when "job"
        @thing = Job.find(self.thing_id)
      when "time_entry"
        @thing = TimeEntry.find(self.thing_id)
    end
    @thing
  end
end