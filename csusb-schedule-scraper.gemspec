Gem::Specification.new do |s|
  s.name = "csusb-schedule-scraper"
  s.version = "0.1"
  s.date = "2013-06-03"
  s.authors = ["Al Wold"]
  s.email = "alwold@alwold.com"
  s.summary = "Scrapes schedule data for CSU San Bernardino"
  s.files = ["lib/csusb_schedule_scraper.rb", "lib/csusb_class_info.rb"]
  s.add_runtime_dependency "nokogiri"
end