namespace :seed do
  desc "TODO"
  task users: :environment do
    puts "Creating Users"
    User.create(username: "doanhuuhoa",
                email: "doan.huu.hoa@sun-asterisk.com",
                password: "123456",
                password_confirmation: "123456",
                phone_number: "0123456789",
                department: "Vietnam Education Unit",
                role: 1)
    User.create(username: "buithikieu",
                email: "bui.thi.kieu@sun-asterisk.com",
                password: "123456",
                password_confirmation: "123456",
                phone_number: "0123456789",
                department: "Vietnam Education Unit",
                role: 1)
    User.create(username: "luongminhtam",
                email: "luong.minh.tam@sun-asterisk.com",
                password: "123456",
                password_confirmation: "123456",
                phone_number: "0123456789",
                department: "Vietnam Education Unit",
                role: 1)
    (1..20).each do |i|
      user = User.new
      user.username = Faker::Internet.unique.username(specifier: 7..9)
      user.email = Faker::Internet.unique.email
      user.password = "123456"
      user.password_confirmation = "123456"
      user.phone_number = "0123456789"
      user.department = Faker::Company.industry
      user.role = i % 2
      user.save
      puts user.errors.messages if user.errors.any?
    end
  end

  task courses: :environment do
    puts "Creating Courses"
    (1..30).each do |i|
      course = Course.new
      course.name = "Course #{i}"
      course.description = Faker::Lorem.unique.sentence
      course.status = rand(0..2)
      course.creator_id=1
      course.day_start = Faker::Date.between(from: "2020/01/01", to: "2020/10/01")
      course.day_end = Faker::Date.between(from: "2020/10/01", to: "2020/12/30")
      course.save
      puts course.errors.messages if course.errors.any?
    end
  end

  task subjects: :environment do
    puts "Creating Subjects"
    (1..100).each do |i|
      subject = Subject.new
      subject.name = "Subject #{i}"
      subject.description = Faker::Lorem.unique.sentence
      subject.status = rand(0..2)
      subject.save
      puts subject.errors.messages if subject.errors.any?
    end
  end

  task tasks: :environment do
    puts "Creating Tasks"
    subject_ids = Subject.pluck(:id)
    (1..300).each do |i|
      task = Task.new
      task.name = "Task #{i}"
      task.subject_id = subject_ids.sample
      task.description = Faker::Lorem.unique.sentence
      task.status = rand(0..2)
      task.step = rand(1..10)
      task.duration = rand(1..100)
      task.save
      puts task.errors.messages if task.errors.any?
    end
  end

  task pivots: :environment do
    puts "Creating data for Pivot Tables"
    course_ids = Course.pluck(:id)
    subject_ids = Subject.pluck(:id)

    User.all.each do |u|
      total_samples = rand(1..(course_ids.length - 1))
      u.courses << Course.find(course_ids.sample(total_samples))
    end

    Course.all.each do |c|
      total_samples = rand(1..(subject_ids.length - 1))
      c.subjects << Subject.find(subject_ids.sample(total_samples))
    end
  end
end
