require 'net/http'
require 'nokogiri'
require_relative 'csusb_class_info'

class CsusbScheduleScraper
  def get_class_info(term_code, course_abbrev, course_number, class_number)
    doc = fetch_info(term_code, course_abbrev, course_number, class_number)
    rows = doc.xpath("//table[tr/th/b/a[text()='Subject']]/tr[td]")
    rows.each do |row|
      cells = row.xpath("td")
      if cells[1].text.strip == class_number
        name = cells[3].text.strip
        schedule = cells[7].text.strip << " " << cells[6].text.strip
        return CsusbClassInfo.new(name, schedule)
      end
    end
    nil
  end

  def get_class_status(term_code, course_abbrev, course_number, class_number)
    doc = fetch_info(term_code, course_abbrev, course_number, class_number)
    rows = doc.xpath("//table[tr/th/b/a[text()='Subject']]/tr[td]")
    rows.each do |row|
      cells = row.xpath("td")
      if cells[1].text.strip == class_number
        open_seats = cells[10].text.split('/')[0].to_i
        if open_seats == 0
          return :closed
        else
          return :open
        end
      end
    end
    nil
  end

private
  def string_value(node)
    if node == nil
      nil
    else
      node.to_s.strip
    end
  end

  def fetch_info(term_code, course_abbrev, course_number, class_number)
    uri = URI("http://info001.csusb.edu/schedule/astra/class.jsp?quarter=#{term_code}&campus=ALL&crseabbrev=#{course_abbrev}&cnmbr=#{course_number}&txc=+&Submit=Submit")
    req = Net::HTTP::Get.new(uri.request_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.start do |http| 
      res = http.request(req)
    end
    doc = Nokogiri::HTML(res.body)
    return doc
  end
end
