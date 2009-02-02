require File.dirname(__FILE__) + '/../../../spec_helper'

module Linkay
  module Gadgets
    module GSpec
      
      describe UserPref do
        it "should parse basic user pref node well" do
          xml = <<EOS
          <UserPref
            name="name"
            display_name="display_name"
            default_value="default_value"
            required="true"
            datatype="hidden"
            urlparam="urlparam"
            autocomplete_url="autocomplete_url"
            num_minval="0"
            num_maxval="10"
            str_maxlen="10"
            restrict_to_completions="true"
            prefix_match="true"
            publish="true"
            listen="false"
            on_change="on_change"
            group="group" />
EOS
          ups = UserPref.new(Nokogiri::XML(xml).root)
          ups.name.should == "name"
          ups.display_name.should == "display_name"
          ups.default_value.should == "default_value"
          ups.required.should be_true
          ups.datatype.should == "hidden"
          ups.urlparam.should == "urlparam"
          ups.autocomplete_url.should == "autocomplete_url"
          ups.num_minval.should == 0
          ups.num_maxval.should == 10
          ups.str_maxlen.should == 10
          ups.restrict_to_completions.should be_true
          ups.prefix_match.should be_true
          ups.publish.should be_true
          ups.listen.should be_false
          ups.on_change.should == "on_change"
          ups.group.should == "group"
        end

        it "should raise exception when missing name attribute" do
          xml = <<EOS
          <UserPref />
EOS
          lambda {
            ups = UserPref.new(Nokogiri::XML(xml).root)          
          }.should raise_error(GSpecParserError, "UserPref's name attribute is required")        
        end

        it "should parse correctly user pref with EnumValue sub elements" do
          xml = <<EOS
          <UserPref
             name="name"
             datatype="enum">
             <EnumValue value="0" default_value="zero" />
             <EnumValue value="1" />
          </UserPref>
EOS

          ups = UserPref.new(Nokogiri::XML(xml).root)
          ups.datatype.should == "enum"
          ups.enum_values[0].should == "zero"
          ups.enum_values[1].should == 1
        end
      end

    end
  end
end
