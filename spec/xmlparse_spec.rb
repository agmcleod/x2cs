require 'spec_helper'

describe XmlParser do
  describe "#init" do
    before(:each) do
      load_test_files
      XmlParser.stub!(:gets).and_return('test_file.xml')
      XmlParser.stub!(:puts)
    end
    
    it "should give a greeting message 'type xml file name'" do
      XmlParser.stub!(:build_headers)
      XmlParser.should_receive(:puts).with('type xml file name')
      XmlParser::init
    end
    
    it "should call build_headers" do
      XmlParser.stub!(:build_headers)
      XmlParser.should_receive(:build_headers)
      XmlParser::init
    end
    
    after(:each) do
      remove_test_files
    end
  end
  
  describe "#build_headers" do
    context "Load test files with 4 headers" do
      before(:each) do
        load_test_files
        XmlParser.stub!(:gets).and_return('Person')
        XmlParser.stub!(:puts)
        f = File.open('test_file.xml')
        @doc = Nokogiri::XML(f)
        f.close
        XmlParser.stub!(:traverse_through_each_row)
      end
      
      it "@headers should be of size 4" do
        XmlParser.send(:build_headers, @doc)
        XmlParser.headers.size.should == 4
      end
      
      it "@headers should contain name" do
        XmlParser.send(:build_headers, @doc)
        XmlParser.headers.include?('name').should be_true
      end
      
      it "@headers should contain email" do
        XmlParser.send(:build_headers, @doc)
        XmlParser.headers.include?('email').should be_true
      end
      
      it "@headers should contain address" do
        XmlParser.send(:build_headers, @doc)
        XmlParser.headers.include?('address').should be_true
      end
      
      it "@headers should contain phone" do
        XmlParser.send(:build_headers, @doc)
        XmlParser.headers.include?('phone').should be_true
      end
      
      after(:each) do
        remove_test_files
      end
    end
    
    context "Traversing node is non-existant" do
      before(:each) do
        load_test_files
        XmlParser.stub!(:gets).and_return('Badtagname')
        XmlParser.stub!(:puts)
        f = File.open('test_file.xml')
        @doc = Nokogiri::XML(f)
        f.close
        XmlParser.stub!(:traverse_through_each_row)
      end
      
      it "raises an exception if tag is not found" do
        lambda { XmlParser.send(:build_headers, @doc) }.should raise_error(RuntimeError, "Tag not found")
      end
      
      after(:each) do
        remove_test_files
      end
    end
  end
  
  describe "#traverse_through_each_row" do
    before(:each) do
      load_test_files_with_extra
      f = File.open('test_file.xml')
      @doc = Nokogiri::XML(f)
      f.close
      
      XmlParser.stub!(:gets).and_return('Person')
      @headers = XmlParser.send(:build_headers, @doc).headers
      XmlParser.stub!(:write_to_file)
    end
    
    it "should populate @rows with 5 objects" do
      XmlParser.send(:traverse_through_each_row, @doc, 'Person')
      XmlParser.rows.size.should == 5
    end
    
    it "row[4] should contain multiple values in email field" do
      XmlParser.send(:traverse_through_each_row, @doc, 'Person')
      r = XmlParser.rows[4]
      puts r
      r.index("1@test.com|2@test.com").should_not be_nil
    end
    
    after(:each) do
      remove_test_files
    end
  end
end