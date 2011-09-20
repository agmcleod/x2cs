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
  
  def headers
    @headers
  end
  
  def rows
    @rows
  end
  
  private
    
  def build_headers(doc)
    @headers = []
    puts "Enter in node name to traverse. If it's an xml table of <Person> objects, type \"Person\" (without quotes)"
    node_to_traverse = gets.chomp
    nodes = doc.css(node_to_traverse)
    if nodes.size == 0
      raise "Tag not found"
    else
      nodes.each do |loc|
        loc.children.each do |field|
          @headers << field.name if field.name != "text" && !@headers.include?(field.name)
        end
      end
      tag_found = true
    end
    traverse_through_each_row(doc, node_to_traverse)
  end
  
  def traverse_through_each_row(doc, node_to_traverse)
    @rows = []
    count = 0
    doc.css(node_to_traverse).each do |loc|
      fields = Array.new(@headers.size)
      loc = populate_missing(loc)
      loc.children.each do |field|
        idx = @headers.index(field.name)
        if field.class == Nokogiri::XML::Element
          f = []
          field.children.each do |c|
            f = recursive_iteration(c, f)
          end
          fields[idx] = "#{enclose(f.join('|'))}"
        end
      end
      count += 1
      @rows << fields.join(',')
    end
    
    write_to_file
  end
  
  def recursive_iteration(c, f)
    if c.class == Nokogiri::XML::Element
      if c.children.size > 0
        c.children.each do |child|
          f = recursive_iteration(child, f)
        end
      end
    else
      text = strip(c.text)
      f << text unless text.empty?
    end
    f
  end
  
  def write_to_file
    File.open("#{@xml_name}.csv", 'w+') do |file|
      file.write(@headers.join(',') + "\n")
      @rows.each do |r|
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
  
  def populate_missing(location)
    h = []
    location.children.each do |c|
      h << c.name if c.name != "text"
    end
    h.sort
    if h != @headers
      h = @headers - h
      h.each { |mh| location.add_child("<#{mh} />") }
    end
    return location
  end
  
  
end