module ApplicationHelper
  # transforms an integer of minutes into xh ym format, e.g.
  #   180 -> 3h
  #   35  -> 35m
  #   263 -> 4h 23m
  #   0 -> 0m
  # check tests for more examples
  def minutes_to_hours_minutes(raw_minutes)
    # calculate the number of hours and minutes in the integer
    hours = raw_minutes / 60
    minutes = raw_minutes % 60

    output = ""

    if hours != 0
      output = "#{hours}h"
    end

    if minutes != 0
      # if there are both hours and minutes, we'll need a space between
      if hours != 0
        output = output + " "
      end

      output = output + "#{minutes}m"
    end

    if hours == 0 and minutes == 0
      output = "0m"
    end

    output
  end
end