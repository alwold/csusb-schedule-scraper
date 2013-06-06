require 'csusb_schedule_scraper'

describe CsusbScheduleScraper, '#get_class_info' do
  it "works for an existing class" do
    scraper = CsusbScheduleScraper.new
    scraper.get_class_status('2136', 'ENG', '107', '60394').should eq(:closed)
    info = scraper.get_class_info('2136', 'ENG', '107', '60394')
    info.name.should eq("ADV FIRST-YEAR COMP")
    info.schedule.should eq("TR 10:00 AM - 11:50 AM")
  end
  it "returns nil for non-existent class" do
    scraper = CsusbScheduleScraper.new
    scraper.get_class_status('2136', 'ENG', '107', '102938908').should eq(nil)
  end
end