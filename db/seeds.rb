# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

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
