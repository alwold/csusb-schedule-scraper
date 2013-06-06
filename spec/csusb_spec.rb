require 'csusb_schedule_scraper'
require './class_info'

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
    info = scraper.get_class_info('2136', 'ENG', '107', '60394')
    info.name.should eq("ADV FIRST-YEAR COMP")
    info.schedule.should eq("TR 10:00 AM - 11:50 AM")
  end
  it "returns nil for non-existent class" do
    scraper.get_class_status('2136', 'ENG', '107', '102938908').should eq(nil)
  end
end

def get_current_term
  doc = get_doc("http://info001.csusb.edu/schedule/astra/schedule.jsp")
  doc.xpath("//select[@name='quarter']/option[@selected='']/@value")
end

def get_class(status)
  doc = get_doc("http://info001.csusb.edu/schedule/astra/schedule.jsp")
  term_code = get_current_term
  abbrev = doc.xpath("//select[@name='crseabbrev']/option[@value != ' ']/@value")[0]
  doc = get_doc("http://info001.csusb.edu/schedule/astra/class.jsp?quarter=#{term_code}&campus=ALL&crseabbrev=#{abbrev}&cnmbr=&txc=+&Submit=Submit")
  course_rows = doc.xpath("//table[tr/th/b/a[text()='Subject']]/tr[td]")
  course_rows.each do |row|
    cells = row.xpath("td")
    available_seats = cells[10].text.split("/")[0].to_i
    if (status == :open && available_seats != 0) || (status == :closed && available_seats == 0)
      course = ClassInfo.new
      course.term_code = term_code
      course.abbrev, course.course_number = cells[0].text.split(" ")
      course.class_number = cells[1].text
      return course
    end
  end
  nil
end

def get_doc(url)
  uri = URI(url)
  req = Net::HTTP::Get.new(uri.request_uri)
  http = Net::HTTP.new(uri.host, uri.port)
  res = http.start do |http| 
    res = http.request(req)
  end
  Nokogiri::HTML(res.body)
end