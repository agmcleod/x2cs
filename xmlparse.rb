require 'rubygems'
require 'nokogiri'

module XmlParser

  def init  
    puts 'type xml file name'
    @xml_name = gets.chomp
    f = File.open(@xml_name)
    doc = Nokogiri::XML(f)
    f.close
    build_headers(doc)
  end
  
  private
    
  def build_headers(doc)
    @headers = []
    puts "Enter in node name to traverse. If it's an xml table of <Person> objects, type \"Person\" (without quotes)"
    node_to_traverse = gets.chomp
    doc.css(node_to_traverse).each do |loc|
      loc.children.each do |field|
        @headers << field.name if field.name != "text" && !@headers.include?(field.name)
      end
    end
    
    traverse_through_each_row(doc, node_to_traverse)
  end
  
  def traverse_through_each_row(doc, node_to_traverse)
    rows = []
    count = 0
    doc.css(node_to_traverse).each do |loc|
      fields = Array.new(@headers.size)
      loc = populate_missing(@headers, loc)
      loc.children.each do |field|
        idx = @headers.index(field.name)
        if field.class == Nokogiri::XML::Element
          f = []
          field.children.each do |c|
            text = strip(c.text)
            f << text unless text.empty?
          end
          fields[idx] = "#{enclose(f.join('|'))}"
        else
          f = enclose_and_strip(field.text)
          fields[idx] = "#{f}" unless f.empty?
        end
      end
      count += 1
      rows << fields.join(',')
    end
    
    write_to_file(rows)
  end
  
  def write_to_file(rows)
    File.open("#{@xml_name}.csv", 'w+') do |file|
      file.write(@headers.join(',') + "\n")
      rows.each do |r|
        file.write("#{r}\n")
      end
    end
  end
  
  def enclose(str)
    if str.index(',')
      return "\"#{str}\""
    else
      return str
    end
  end
  
  def enclose_and_strip(str)
    return enclose(strip(str))
  end
  
  def strip(str)
    return str.gsub(/\n|\t/, '').strip
  end
  
  def populate_missing(headers, location)
    h = []
    location.children.each do |c|
      h << c.name if c.name != "text"
    end
    h.sort
    if h != headers
      h = headers - h
      h.each { |mh| location.add_child("<#{mh} />") }
    end
    return location
  end
  
  
end