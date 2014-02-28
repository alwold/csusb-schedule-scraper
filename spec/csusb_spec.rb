require 'csusb_schedule_scraper'
require './class_info'
require 'csusb_spec_helpers.rb'

RSpec.configure do |config|
  config.include CsusbSpecHelpers
end

describe CsusbScheduleScraper, '#get_class_info' do
  scraper = CsusbScheduleScraper.new
  it "can load open class" do
    c = get_class :open
    c.should be_an_instance_of(ClassInfo)
    c.abbrev.should_not be_nil
  end
  it "open class shows open status" do
    open = get_class :open
    scraper.get_class_status(open.term_code, open.abbrev, open.course_number, open.class_number).should eq(:open)
  end
  it "closed class shows closed status" do
    closed = get_class :closed
    scraper.get_class_status(closed.term_code, closed.abbrev, closed.course_number, closed.class_number).should eq(:closed)
  end
  it "class info can be loaded" do
    # TODO we need some way to validate that the title and schedules of a class
    # look like a title/schedule, rather than just pulling from the table and making
    # sure the scraper sees the same
    info = scraper.get_class_info('2144', 'ACCT', '211', '40771')
    info.name.should eq("INTRO ACCT I")
    info.schedule.should eq("MW 2:00 PM - 3:50 PM")
  end
  it "returns nil for non-existent class" do
    scraper.get_class_status('2136', 'ENG', '107', '102938908').should eq(nil)
  end
end

