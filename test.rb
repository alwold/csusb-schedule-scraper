require './lib/csusb_schedule_scraper.rb'

s = CsusbScheduleScraper.new
puts s.get_class_status('2136', 'ENG', '107', '60394')

info = s.get_class_info('2136', 'ENG', '107', '60394')
if info.nil?
  puts "no info"
else
  puts "Name: " << info.name 
  puts "Schedule: " << info.schedule
end

puts s.get_class_status('2136', 'ENG', '107', '102938908')
puts s.get_class_status('2136', 'ENG', '1012317', '102938908')
