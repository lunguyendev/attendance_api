# frozen_string_literal: true

include Util::Generation

puts "Start"
# Config defaut language
Faker::Config.locale = :vi

# Create account user
password_user = generate_hash_password("password123")
student = Student.create(
  email: "student@gmail.com",
  hashed_password: password_user,
  role: 0,
  name: Faker::Name.name_with_middle,
  phone: Faker::PhoneNumber.phone_number,
  gender: 0,
  birthday: Faker::Date.birthday(min_age: 18, max_age: 30),
  id_student: Faker::Number.number(digits: 6),
  avatar: Faker::Company.logo
)
lecture = Lecturer.create(
  email: "lecture@gmail.com",
  hashed_password: password_user,
  role: 1,
  name: Faker::Name.name_with_middle,
  phone: Faker::PhoneNumber.phone_number,
  gender: 0,
  birthday: Faker::Date.birthday(min_age: 18, max_age: 30),
  id_lecturer: Faker::Number.number(digits: 6),
  avatar: Faker::Company.logo
)
admin1 = Admin.create(
  email: "admin@gmail.com",
  hashed_password: password_user,
  role: 2,
  name: "Admin",
  phone: Faker::PhoneNumber.phone_number,
  gender: 0,
  birthday: Faker::Date.birthday(min_age: 18, max_age: 30),
  id_lecturer: Faker::Number.number(digits: 6),
  avatar: Faker::Company.logo
)

admin = Admin.create(
  email: "nguyen.van.a@school.com",
  hashed_password: password_user,
  role: 2,
  name: "Nguyen van A",
  phone: Faker::PhoneNumber.phone_number,
  gender: 0,
  birthday: Faker::Date.birthday(min_age: 18, max_age: 30),
  id_lecturer: Faker::Number.number(digits: 6),
  avatar: Faker::Company.logo
)


(1..200).to_a.each do
  user_param = {
    name: Faker::Name.name_with_middle,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.phone_number,
    gender: [0,1].sample,
    birthday: Faker::Date.birthday(min_age: 18, max_age: 30),
    id_student: Faker::Number.number(digits: 6),
    avatar: Faker::Company.logo,
    hashed_password: password_user,
    role: 0
  }
  Student.create!(user_param)
end

(1..20).to_a.each do
  user_param = {
    name: Faker::Name.name_with_middle,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.phone_number,
    gender: [0,1].sample,
    birthday: Faker::Date.birthday(min_age: 25, max_age: 50),
    id_lecturer: Faker::Number.number(digits: 6),
    avatar: Faker::Company.logo,
    hashed_password: password_user,
    role: 1
  }
  Lecturer.create!(user_param)
end

User.update_all(status: "actived")

lecture_uids = Lecturer.all.pluck(:uid)

(1..20).to_a.each do
  date = Faker::Date.between(from: '2021-10-24', to: '2022-01-01')
  param = {
    user_uid: admin1.uid,
    name: Faker::Educator.course_name,
    size: 50,
    lecture_uid: lecture_uids.sample,
    description: Faker::Lorem.words(number: 40),
    img: Faker::Company.logo,
    location: "Room #{(1..20).to_a.sample}",
    status: 2,
    start_at: date,
    end_at: date+60.days
  }
  subject = Subject.create!(param)
  number_join =(30..50).to_a.sample
  subject.number_join = number_join
  subject.save!

  students = Student.all.sample(number_join)

  students.each do |student|
    student.take_part_in_subjects.create!({subject_uid: subject.uid})
  end

  dates = [date, date + 2.days, date + 5.days,  date + 7.days, date + 10.days, date + 14.days, date + 20.days, date + 25.days, date + 30.days]
  dates.each do |date|
    qr_code = subject.qr_codes.create!({
        qr_code_string: generate_token,
        date: date,
        expired_at: "Sat, 21 May 2022 09:07:20 +0700"
    })
    students_arr = students.sample(number_join - 4)
    students_arr.each do |student|
      attendance = Attendance.new
      attendance.student_uid = student.uid
      attendance.qr_code_uid = qr_code.uid
      attendance.date = date
      attendance.subject_uid = subject.uid
      attendance.save!
    end
  end
end

(1..15).to_a.each do
  date = Faker::Date.between(from: '2021-06-01', to: '2022-07-01')
  param = {
    user_uid: admin1.uid,
    name: Faker::Educator.course_name,
    size: 50,
    lecture_uid: lecture_uids.sample,
    description: Faker::Lorem.words(number: 40),
    img: Faker::Company.logo,
    location: "Room #{(1..20).to_a.sample}",
    status: 1,
    start_at: date,
    end_at: date+60.days
  }
  subject = Subject.create!(param)
  number_join =(30..50).to_a.sample
  subject.number_join = number_join
  subject.save!

  number_student = (20..40).to_a.sample
  students = Student.all.sample(number_student)

  students.each do |student|
    student.take_part_in_subjects.create!({subject_uid: subject.uid})
  end
end

(1..40).to_a.each do
  date = Faker::Date.between(from: '2021-08-01', to: '2022-12-01')
  param = {
    user_uid: admin1.uid,
    name: Faker::Educator.course_name,
    size: 50,
    lecture_uid: lecture_uids.sample,
    description: Faker::Lorem.words(number: 40),
    img: Faker::Company.logo,
    location: "Room #{(1..20).to_a.sample}",
    status: 0,
    start_at: date,
    end_at: date+60.days
  }
  subject = Subject.create!(param)
end
puts "end"
