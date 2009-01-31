require File.dirname(__FILE__) + '/../../../spec_helper'

module Linkay
  module Gadgets
    module GSpec

      describe GadgetSpec do
        it "should work with basic gadget xml" do
          gadget_xml = <<EOF
<Module>
  <ModulePrefs title="title" />
  <UserPref name="foo" datatype="string" />
  <Content type="html">Hello</Content>
</Module>
EOF
          gspec  = GadgetSpec.new(SPEC_URL, gadget_xml)
          gspec.url.should == "http://example.org/g.xml"
          gspec.modulePrefs.should be_an_instance_of(ModulePrefs)
          gspec.userPrefs.should be_an_instance_of(Array)
          gspec.userPrefs[0].should be_an_instance_of(UserPref)
          gspec.views.should be_an_instance_of(Hash)
          gspec.views['default'].should be_an_instance_of(View)
        end

        it "should raise exception when missing or have more than one module prefs" do
          gadget_xml = <<EOF
<Module>
  <UserPref name="foo" datatype="string" />
  <Content type="html">Hello</Content>
</Module>
EOF
          lambda{
            gspec  = GadgetSpec.new(SPEC_URL, gadget_xml)          
          }.should raise_error(GSpecParserError, "Exactly 1 ModulePrefs is required!")
          gadget_xml = <<EOF
<Module>
  <ModulePrefs title="title" />
  <ModulePrefs title="title2" />
  <UserPref name="foo" datatype="string" />
  <Content type="html">Hello</Content>
</Module>
EOF
          lambda{
            gspec  = GadgetSpec.new(SPEC_URL, gadget_xml)          
          }.should raise_error(GSpecParserError, "Exactly 1 ModulePrefs is required!")
        end

        it "should work with conent" do
          gadget_xml = <<EOS
<Module>
  <ModulePrefs title="title" />
  
</Module>
EOS
        end

      end
    end
  end
end
