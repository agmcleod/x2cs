require 'spec_helper'

describe XmlParser do
  describe "init" do
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
end