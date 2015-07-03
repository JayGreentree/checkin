# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'csv'

# Checkin Session Types
puts "Creating checkin session types"
puts "=============================="
[
  [ "floor", "Floor"],
  [ "building", "Building"],
  [ "event", "Event"]
].each do |t|
  puts " * #{t[1]} (#{t[0]})"
  s = CheckinSessionType.find_or_create_by key: t[0]
  s.update_attributes( label: t[1] )
end
puts ""

# Checkin Sessions
start_date = Date.parse('2015-06-27')
end_date =   Date.parse('2015-08-09')

puts "Creating building checkin sessions"
puts "=================================="
puts " Start: #{start_date.to_s(:checkin_label)}"
puts "   End: #{end_date.to_s(:checkin_label)}"
t = CheckinSessionType.find_by_key 'building'
(start_date..end_date).each do |d|
  e = CheckinSession.find_or_create_by( checkin_session_type: t, check_in_by: d.to_checkin_datetime(:building), key: "morewood" )
  e.update_attributes( label: e.check_in_by.to_s(:checkin_label) )
end
puts ""

puts "Creating floor checkin sessions"
puts "==============================="
puts " Start: #{start_date.to_s(:checkin_label)}"
puts "   End: #{end_date.to_s(:checkin_label)}"
t = CheckinSessionType.find_by_key 'floor'
(start_date..end_date).each do |d|
  ["2","3","4","5","6","E3","E4","E5","E6","E7"].each do |f|
    e = CheckinSession.find_or_create_by( checkin_session_type: t, check_in_by: d.to_checkin_datetime(:floor), key: "#{f}" )
    e.update_attributes( label: "#{e.check_in_by.to_s(:checkin_label)} - Floor #{f}" )
  end
end
puts ""


# Add Exec
# "Name","Phone","Andrew ID","Email","Position","Building","Room #"
# "Susie Rush","(000) 000-0000","ssheldon","test@precollege.andrew.cmu.edu","Program Director","",""
puts "Adding exec"
puts "==========="
csv_text = File.read("#{Rails.root}/db/seeds/#{Rails.env}/exec.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  puts " * #{row[0]} - #{row[4]}"
  u = User.find_or_create_by andrewid: row[2]
  u.update_attributes( cell_number: row[1],
                       dorm: row[5],
                       room: row[6],
                       title: row[4],
                       admin: true,
                       staff: true )
end
puts ""

# Add Counselors
#  "Name","Phone","Andrew ID","Email","Position","Building","Room #","Partner"
#  "Peter Friedman","(000) 000-0000","pfriedma","test@precollege.andrew.cmu.edu","Counselor","E-Tower","E100","adrake"
puts "Adding counselors"
puts "================="
csv_text = File.read("#{Rails.root}/db/seeds/#{Rails.env}/counselors.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  puts " * #{row[0]} - #{row[4]}"
  u = User.find_or_create_by andrewid: row[2]
  p = User.find_or_create_by andrewid: row[7] unless row[7].nil?
  u.update_attributes( cell_number: row[1],
                       dorm: row[5],
                       room: row[6],
                       title: row[4],
                       partner: p,
                       staff: true,
                       admin: false )
end
puts ""


# Add Checkin Session Owners
puts "Adding building checkin session owners"
puts "======================================"
t = CheckinSessionType.find_by_key 'building'
t.checkin_sessions.find_each do |s|
  puts " * #{s.label}"
  User.staff.map{ |o| CheckinSessionOwner.find_or_create_by( checkin_session: s, user: o ) }
end
puts ""

puts "Adding floor checkin session owners"
puts "==================================="
t = CheckinSessionType.find_by_key 'floor'
t.checkin_sessions.find_each do |s|
  owners = User.counselors.where("room like ?", "#{s.key[-1]}%")
  owners = s.key[0] == "E" ? owners.where(dorm: "E-Tower") :
             owners.where.not(dorm: "E-Tower")
  puts " * #{s.label}: #{owners.pluck(:andrewid).join(', ')}"
  owners.map{ |o| CheckinSessionOwner.find_or_create_by( checkin_session: s, user: o ) }
end
puts ""

# Add Programs
puts "Adding programs"
puts "==============="
[
  ["APEA","APEA"],
  ["ARC","Architecture"],
  ["ART","Art"],
  ["DRA","Drama"],
  ["ETC","ETC"],
  ["MUS","Music"]
].each do |p|
  puts " * #{p[0]} - #{p[1]}"
  u = Program.find_or_create_by key: p[0]
  u.update_attributes( label: p[1] )
end
puts ""

# Add Commuters
# "Andrew","Program"
# "azl","APEA"
puts "Adding commuters"
puts "================"
csv_text = File.read("#{Rails.root}/db/seeds/#{Rails.env}/commuters.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  p = Program.find_by_key row[1]
  u = User.find_or_create_by andrewid: row[0]
  u.update_attributes( program: p, staff: false, admin: false )
  puts " * #{u.andrewid}"
end
puts ""

# Add Residents
# "Room","Andrew ID","Counselor1","Counselor2","Program"
# "201","meribyte","mmackie","pfriedma","DRA"
puts "Adding residents & default checkins"
puts "==================================="
csv_text = File.read("#{Rails.root}/db/seeds/#{Rails.env}/residents.csv")
csv = CSV.parse(csv_text, :headers => true)
building_checkin = CheckinSessionType.find_by_key 'building'
floor_checkin = CheckinSessionType.find_by_key 'floor'
csv.each do |row|
  p = Program.find_by_key row[4]
  u = User.find_or_create_by andrewid: row[1]
  room = row[0]
  dorm = "Morewood Gardens"
  floor_key = room[0] # First number in room
  if floor_key == "E" # E-Tower
    room = room.split('E')[1]
    dorm = "E-Tower"
    floor_key = "E#{room[0]}"
  end
  u.update_attributes( room: room,
                       dorm: dorm,
                       program: p,
                       staff: false,
                       admin: false )
  u.counselors.destroy_all
  UserCounselor.create( user: u, counselor: User.find_by( andrewid: row[2] ) )
  UserCounselor.create( user: u, counselor: User.find_by( andrewid: row[3] ) )

  # Add Prekies to Checkins
  building_checkin.checkin_sessions.each do |t|
    CheckinUser.create( checkin_session: t, user: u )
  end
  floor_checkin.checkin_sessions.where(key: floor_key).each do |t|
    CheckinUser.create( checkin_session: t, user: u )
  end
  puts " * #{u.andrewid}"
end
puts ""
