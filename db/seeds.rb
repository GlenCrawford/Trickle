[
  ["Administrator", "This is God. Can create, view, edit and delete anything."],
  ["Project manager", "Can create and edit estimates, jobs and tasks."],
  ["Team leader", "Can create and edit users."],
  ["Basic user", "Can pretty much login, add time to a job, and that's it."]
].each do |role|
  Role.create :name => role[0], :description => role[1]
end

User.create :first_name => "Glen",
            :last_name => "Crawford",
            :nick_name => "Glen",
            :email => "glc233@student.cpit.ac.nz",
            :username => "glen",
            :telephone_number => "03 376 6285",
            :mobile_number => "027 423 9864",
            :password => "roadtolostwithiel",
            :avatar => "/images/avatars/glen.gif",
            :role_id => Role.find_by_name("Administrator").id

Thread.current[:user] = User.first

User.create :first_name => "Mike",
            :last_name => "Lance",
            :nick_name => "Mike",
            :email => "lancem@cpit.ac.nz",
            :username => "mike",
            :telephone_number => "03 930 2940",
            :mobile_number => "027 592 0359",
            :password => "whiskypy",
            :avatar => "/images/avatars/mike.gif",
            :role_id => Role.find_by_name("Team leader").id

User.create :first_name => "Aimee",
            :last_name => "Borich",
            :nick_name => "Aimee",
            :email => "aimee@student.cpit.ac.nz",
            :username => "aimee",
            :telephone_number => "03 459 3404",
            :mobile_number => "027 954 3240",
            :password => "aimeebor",
            :avatar => "/images/avatars/aimee.gif",
            :role_id => Role.find_by_name("Basic user").id

User.create :first_name => "Matthew",
            :last_name => "Burnett",
            :nick_name => "Matt",
            :email => "matt@student.cpit.ac.nz",
            :username => "matt",
            :telephone_number => "03 491 4920",
            :mobile_number => "027 934 9034",
            :password => "needlesp",
            :avatar => "/images/avatars/matt.gif",
            :role_id => Role.find_by_name("Project manager").id

Settings.create :daily_resource_amount => 100,
                :billable => 1,
                :company_code => "LCK",
                :company_name => "LeftClick",
                :low_utilization_level => 60,
                :high_utilization_level => 90

[
  ["NLV", "NextLevel"],
  ["MFT", "Microsoft"],
  ["IBM", "International Business Machines"],
  ["GLN", "Glen Crawford, Inc."],
  ["UoC", "University of Canterbury"],
  ["SNY", "Sony"],
  ["CPT", "CPIT"]
].each do |client|
  Client.create :code => client[0], :name => client[1]
end

[
  ["DEV", "Developer", 200],
  ["ViD", "Visual designer", 150],
  ["UxD", "User experience designer", 180],
  ["SEO", "Search engine optimizer", 170],
  ["OMC", "Online marketing consultant", 190]
].each do |resource_type|
  ResourceType.create :code => resource_type[0], :name => resource_type[1], :rate => resource_type[2]
end

[
  ["SEO for Sony", "1", 50, "open", "Sony", nil, nil, "Glen", Time.now, "Glen", Time.now]
].each do |estimate|
  Estimate.create :name => estimate[0],
                  :number => estimate[1],
                  :budget => estimate[2],
                  :status => estimate[3],
                  :client_id => Client.find_by_name(estimate[4]).id,
                  :estimate_id => estimate[5],
                  :owner_id => estimate[6],
                  :creator_id => User.find_by_first_name(estimate[7]).id,
                  :created_at => estimate[8],
                  :updater_id => User.find_by_first_name(estimate[9]).id,
                  :updated_at => estimate[10]
end

[
  ["Trickle", "2", 288, "open", "CPIT", nil, "Glen", "Glen", Time.now, "Glen", Time.now, [User.find_by_first_name("Glen"), User.find_by_first_name("Mike")]],
  ["New visual design for Microsoft", "3", 50, "open", "Microsoft", nil, "Glen", "Glen", Time.now, "Glen", Time.now, [User.find_by_first_name("Glen"), User.find_by_first_name("Aimee"), User.find_by_first_name("Matthew"), User.find_by_first_name("Mike")]]
].each do |job|
  Job.create  :name => job[0],
              :number => job[1],
              :budget => job[2],
              :status => job[3],
              :client_id => Client.find_by_name(job[4]).id,
              :estimate_id => job[5],
              :owner_id => User.find_by_first_name(job[6]).id,
              :creator_id => User.find_by_first_name(job[7]).id,
              :created_at => job[8],
              :updater_id => User.find_by_first_name(job[9]).id,
              :updated_at => job[10],
              :users => job[11]
end

[
  ["Meet and discuss previous SEO attempts", 1, "SEO for Sony", nil, nil, "Send John and Sue", "open", nil, true, "SEO", 2, 340, []],
  ["Hook up an analytics system to their site", 2, "SEO for Sony", nil, nil, "Use Google's Analytics", "open", nil, true, "SEO", 3, 510, []],
  ["Monitor progress on their site", 3, "SEO for Sony", nil, nil, "One hour a week for two weeks", "open", nil, true, "SEO", 1, 170, []],
  ["Meet with clients again and discuss next steps", 4, "SEO for Sony", nil, nil, "Make sure to take Analytic data", "open", nil, true, "SEO", 2, 340, []],
  ["Meet with Microsoft reps", 1, "New visual design for Microsoft", nil, nil, "Send Jill and Bob", "open", 6, true, "ViD", 2, 300, [User.find_by_first_name("Glen")]],
  ["Have visual design team work on a couple of concepts", 2, "New visual design for Microsoft", nil, nil, "Put the whole ViD team on this one", "open", 16, true, "ViD", 5, 750, [User.find_by_first_name("Glen")]],
  ["Get feedback from Microsoft on designs", 3, "New visual design for Microsoft", nil, nil, "Set up a rep there so we know who to call", "open", 3, true, "ViD", 1, 150, [User.find_by_first_name("Glen")]],
  ["Put more work into the approved design", 4, "New visual design for Microsoft", nil, nil, "Again, the whole team", "open", 16, true, "ViD", 5, 750, [User.find_by_first_name("Glen")]],
  ["Send the new visual design to development for implementation", 5, "New visual design for Microsoft", nil, nil, "Just our guru developer", "open", 3, true, "DEV", 1, 200, [User.find_by_first_name("Mike")]],
  ["Upload to the hosting service and make it live", 6, "New visual design for Microsoft", nil, nil, "Use GoDaddy as the host", "open", 3, true, "OMC", 1, 190, [User.find_by_first_name("Matthew")]]
].each do |task|
  Task.create :name => task[0],
              :number => task[1],
              :project_id => Project.find_by_name(task[2]).id,
              :start_date => task[3],
              :end_date => task[4],
              :note => task[5],
              :status => task[6],
              :budget => task[7],
              :billable => task[8],
              :resource_type_id => ResourceType.find_by_code(task[9]).id,
              :quantity => task[10],
              :unit_cost => task[11],
              :users => task[12]
end

[
  ["Create a function model", 1, "Trickle", nil, nil, "", "open", 25, true, [User.find_by_first_name("Glen")]],
  ["Create a data model", 2, "Trickle", nil, nil, "Logical and physical", "open", 50, true, [User.find_by_first_name("Glen")]],
  ["Set up a Rails project, MySQL, and Devise", 3, "Trickle", nil, nil, "Check what the latest version of PostgreSQL is", "open", 20, true, [User.find_by_first_name("Glen")]],
  ["Allow the creation of roles", 4, "Trickle", nil, nil, "", "open", 8, true, [User.find_by_first_name("Glen")]],
  ["Allow the admin to create users", 5, "Trickle", nil, nil, "", "open", 20, true, [User.find_by_first_name("Glen")]],
  ["Allow the admin to set the settings", 6, "Trickle", nil, nil, "", "open", 15, true, [User.find_by_first_name("Glen")]],
  ["Record all user's activities", 7, "Trickle", nil, nil, "", "open", 20, true, [User.find_by_first_name("Glen")]],
  ["Be able to create estimates", 8, "Trickle", nil, nil, "", "open", 20, true, [User.find_by_first_name("Glen")]],
  ["Be able to create jobs", 9, "Trickle", nil, nil, "", "open", 50, true, [User.find_by_first_name("Glen")]],
  ["Add tasks to estimates and jobs", 10, "Trickle", nil, nil, "", "open", 15, true, [User.find_by_first_name("Glen")]],
  ["Convert an estimate into a job", 11, "Trickle", nil, nil, "", "open", 10, true, [User.find_by_first_name("Glen")]],
  ["All the rest", 12, "Trickle", nil, nil, "", "open", 27, true, [User.find_by_first_name("Glen")]]
].each do |task|
  Task.create :name => task[0],
              :number => task[1],
              :project_id => Project.find_by_name(task[2]).id,
              :start_date => task[3],
              :end_date => task[4],
              :note => task[5],
              :status => task[6],
              :budget => task[7],
              :billable => task[8],
              :users => task[9]
end

[
  [1, "estimate", "created"],
  [2, "job", "created"],
  [2, "job", "updated"],
  [2, "estimate", "created"],
  [3, "job", "Converted estimate 'New visual design for Microsoft' to"],
  [3, "job", "updated"]
].each do |activity|
  Activity.create activity[0], activity[1], activity[2]
end

[
  [5, 45, 0, 0, "Went really well: our contact there is called 'Bob'. He will be our liason", "Matthew", "Meet with Microsoft reps"],
  [10, 0, 0, 0, "", "Glen", "Have visual design team work on a couple of concepts"],
  [6, 0, 3, 0, "Need more time to polish; three hours should be enough", "Glen", "Have visual design team work on a couple of concepts"],
  [2, 0, 0, 0, "", "Glen", "Get feedback from Microsoft on designs"],
  [10, 0, 0, 0, "", "Aimee", "Put more work into the approved design"],
  [4, 30, 0, 0, "", "Glen", "Put more work into the approved design"],
  [1, 25, 2, 30, "Two and a half hours tomorrow and it should be finished", "Glen", "Put more work into the approved design"],
  [1, 0, 0, 0, "", "Mike", "Send the new visual design to development for implementation"],
  [1, 30, 0, 0, "", "Mike", "Send the new visual design to development for implementation"],
  [0, 30, 2, 0, "Need way more time. Who estimated this task?!", "Glen", "Send the new visual design to development for implementation"],
  [2, 0, 0, 0, "Perfect. +2 hours was all I needed", "Mike", "Send the new visual design to development for implementation"],
  [3, 0, 0, 0, "Up and tested", "Glen", "Upload to the hosting service and make it live"]
].each do |time_entry|
  TimeEntry.create  :time_spent_hours => time_entry[0],
                    :time_spent_minutes => time_entry[1],
                    :extra_time_hours => time_entry[2],
                    :extra_time_minutes => time_entry[3],
                    :note => time_entry[4],
                    :user_id => User.find_by_first_name(time_entry[5]).id,
                    :task_id => Task.find_by_name(time_entry[6]).id
end