# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Criação de um usuário administrador
# admin_user = User.create!(
#   email: 'admin@admin.com',
#   password: 'admin123',
#   is_admin: true,
# )

# Seed the admin user
admin_user = User.find_or_create_by!(email: 'admin@admin.com') do |user|
  user.password = 'admin123'
  user.is_admin = true
end

# Clear existing data (optional but recommended for clean seeding)
# Skip deletion for admin user
User.where.not(email: admin_user.email).destroy_all
Program.destroy_all
Step.destroy_all

# Create 2 programs
2.times do |i|
  Program.create!(
    title: "Program #{i + 1}",
    description: "Description for Program #{i + 1}",
    registration_start_date: Date.today,
    registration_end_date: Date.today + 30,
    begin_date: Date.today + 60,
    end_date: Date.today + 90,
    registration_limit: 100,
    active: true,
    completed: false
  )
end

# Create 2 steps for each program with valid dates
Program.all.each do |program|
  2.times do |j|
    Step.create!(
      program_id: program.id,
      name: "Step #{j + 1} of #{program.title}",
      step_order: j,
      submission: true,
      active: true,
      dates: [Date.today + (j * 10), Date.today + (j * 10) + 5] # Example dates
    )
  end
end

# Create 40 users
40.times do |k|
  birth_year = rand(1973..2005)
  birth_month = rand(1..12)
  birth_day = rand(1..28)
  User.create!(
    email: "user#{k + 1}@example.com",
    password: '123456',
    name: "User #{k + 1}",
    birth_date: Date.new(birth_year, birth_month, birth_day),
    gender: ['Masculino', 'Feminino', 'Outro'].sample,
    is_admin: false
  )
end

# Assign 15 users to the first program and 25 to the second program
first_program = Program.first
second_program = Program.second

# Assign users to the first step of each program
first_step_first_program = first_program.steps.order(:step_order).first
second_step_first_program = second_program.steps.order(:step_order).first

User.limit(15).each do |user|
  UsersProgramsStep.create!(user: user, program: first_program, step: first_step_first_program)
end

User.offset(15).limit(25).each do |user|
  UsersProgramsStep.create!(user: user, program: second_program, step: second_step_first_program)
end
