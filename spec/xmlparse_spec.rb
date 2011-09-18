require 'spec_helper'

describe XmlParser do
  
  describe "init" do
    before(:each) do
      stub!(:gets).and_return('')
      stub!(:puts)
    end
    
    it "should give a greeting message 'type xml file name'" do
      XmlParser.stub!(:build_headers).with(nil)
      should_receive(:puts).with('type xml file name')
      XmlParser::init
    end
    
    
  end
end