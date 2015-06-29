# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


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


# Exec
puts "Creating exec"
puts "============="
[
  ["Andrew Carnegie","(412) 268-1000","andrew","Program Director","","","","","","",""]
].each do |c|
  puts " * #{c[0]} - #{c[4]}"
  u = User.find_or_create_by andrewid: c[2]
  u.update_attributes( cell_number: c[1], dorm: c[6], room: c[8], title: c[4], admin: true )
end
puts ""

# Counselors
# cat /tmp/c.csv | sed 's/^/["/;s/,/","/g;s/$/"],/'
puts "Creating counselors"
puts "==================="
[
  ["Andrew Mellon","","amellon","","Counselor","Morewood Garden","Morewood Gardens - A Tower","1","123","A","Henry Clay Frick"],
  ["Henry Clay Frick","","hcfrick","","Counselor","Morewood Garden","Morewood Gardens - A Tower","1","124","A","Andrew Mellon"]
].each do |c|
  puts " * #{c[0]} - #{c[4]}"
  u = User.find_or_create_by andrewid: c[2]
  u.update_attributes( cell_number: c[1], dorm: c[6], room: c[8], title: c[4], partner: u )
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
  owners = s.key[0] == "E" ? owners.where("dorm like ?", "%E Tower") :
             owners.where.not("dorm like ?", "%E Tower")
  puts " * #{s.label}: #{owners.pluck(:andrewid).join(', ')}"
  owners.map{ |o| CheckinSessionOwner.find_or_create_by( checkin_session: s, user: o ) }
end
puts ""

