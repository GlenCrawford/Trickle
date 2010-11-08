class Job < Project
  validate :user_checkboxes
  validates_presence_of :owner_id

  def owner
    User.find owner_id
  end

  def user_checkboxes
    errors.add("At least one user", "must be selected") if user_ids.size == 0
  end

  def time_spent
    time_spent_count = 0
    tasks.each do |task|
      time_spent_count += task.time_spent
    end
    time_spent_count
  end

  def total_extra_times
    total_extra_time_count = 0
    tasks.each do |task|
      total_extra_time_count += task.total_extra_times
    end
    total_extra_time_count
  end

  def total_tasks_budgets
    total_tasks_budgets_count = 0
    tasks.each do |task|
      total_tasks_budgets_count += task.budget
    end
    total_tasks_budgets_count * 60
  end

  def remaining
    ((total_tasks_budgets.to_f + total_extra_times.to_f) - time_spent.to_f).to_i
  end

  def forecast
    (time_spent.to_f + remaining.to_f + total_extra_times.to_f).to_i
  end

  def outlook
    ((budget * 60).to_f - forecast.to_f).to_i
  end

  def progress
    job_progress = (time_spent.to_f / forecast.to_f) * 100
    if job_progress.nan?
      job_progress = 0
    elsif job_progress.infinite?
      job_progress = 0
    end
    job_progress.to_i
  end
end