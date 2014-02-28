module CsusbSpecHelpers
  def get_current_term
    doc = get_doc("http://info001.csusb.edu/schedule/astra/schedule.jsp")
    doc.xpath("//select[@name='quarter']/option[@selected='selected']/@value")
  end

  def get_class(status)
    doc = get_doc("http://info001.csusb.edu/schedule/astra/schedule.jsp")
    term_code = get_current_term
    abbrev = doc.xpath("//select[@name='crseabbrev']/option[@value != ' ']/@value")[0]
    doc = get_doc("http://info001.csusb.edu/schedule/astra/class.jsp?quarter=#{term_code}&campus=ALL&crseabbrev=#{abbrev}&cnmbr=&txc=+&Submit=Submit")
    course_rows = doc.xpath("//table[tr/th//a[text()='Subject']]/tr[td]")
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
end

