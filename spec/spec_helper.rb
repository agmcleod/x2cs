$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))
require 'xmlparse.rb'
include XmlParser

class Person
  attr_accessor :name, :email, :phone, :address
  
  def initialize(args)
    args.each do |k, v|
      send("#{k}=".to_sym, v)
    end
  end
  
  def to_xml
    "<Person><name>#{name}</name><email>#{email}</email><phone>#{phone}</phone><address>#{address}</address></Person>"
  end
end

def xml_header
  '<?xml version="1.0" encoding="utf-8" ?>'
end

def load_test_files
  write_tests_to_file(add_people)
end

def write_tests_to_file(people)
  File.open('test_file.xml', 'w+') do |f|
    f.write("#{xml_header}\n")
    f.write("<people>")
    people.each do |p|
      f.write("#{p.to_xml}\n")
    end
    f.write("</people>")
  end
end

def load_test_files_with_extra
  people = add_people
  people << Person.new(name: 'Jack johnson', email: '<emails><email>1@test.com</email><email>2@test.com</email></emails>', 
    phone: '555-233-3333', address: '444 test')
  people
  write_tests_to_file(people)
end

def load_test_files_with_missing
  people = add_people
  File.open('test_file.xml', 'w+') do |f|
    f.write("#{xml_header}\n")
    f.write("<people>")
    people.each do |p|
      f.write("#{p.to_xml}\n")
    end
    f.write("<Person><name>A test name</name><email>something@you.com</email><address>test address</address></Person>\n")
    f.write("</people>")
  end
end

def add_people
  people = []
  people << Person.new(name: 'A person', email: 'test@something.com', phone: '555-233-3333', address: '444 test')
  people << Person.new(name: 'John Smith', email: 'jsmith@fake.com', phone: '555-249-8833', address: '123 fake st')
  people << Person.new(name: 'Jane Doe', email: 'example@something.ca', phone: '232-855-3422', address: '8643 Avenue Lane')
  people << Person.new(name: 'Willis', email: 'nonexistant@example.com', phone: '416-233-7688', address: 'a test address')
  people
end

def remove_test_files
  File.delete('test_file.xml')
end