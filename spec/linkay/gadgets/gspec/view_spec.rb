require File.dirname(__FILE__) + '/../../../spec_helper'

module Linkay
  module Gadgets
    module GSpec
      
      describe View do
        it "should parse basic single content with html well" do
          xml = <<EOS
          <content
            type="html"
            preferred_height="400"
            preferred_width="300">
              hello
          </content>
EOS
          view = View.new("default", Nokogiri::XML(xml).root, SPEC_URL)
          view.content_type.should == "html"
          view.preferred_height.should == 400
          view.preferred_width.should == 300
          view.content.strip.should == "hello"
        end
      
        it "should parse basic single content within cdata with plan text well" do
          xml = <<EOS
          <content
            type="html">
            <![CDATA[
              hello
            ]]>
          </content>
EOS
          view = View.new("default", Nokogiri::XML(xml).root, SPEC_URL)
          view.content.strip.should == "hello"
        end

        it "should parse basic single content within cdata with xml tag well" do
          xml = <<EOS
          <content
            type="html">
            <![CDATA[
              <hello/>
            ]]>
          </content>
EOS
          view = View.new("default", Nokogiri::XML(xml).root, SPEC_URL)
          view.content.strip.should == "<hello/>"
        end

        it "should be default view if no view attribute specified" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html">default content</Content>
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].should be_an_instance_of(View)
          gspec.views['default'].name.should == 'default'
          gspec.views['default'].content.strip.should == 'default content'
        end

        it "should concatenate two views when given two default view plan text content" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html">default content 1=</Content>
            <Content type="html" view="default">=default content 2</Content>
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].should be_an_instance_of(View)
          gspec.views['default'].content.should == "default content 1==default content 2"
        end

        it "should concatenate two view when given two default view of xml tags" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html"><![CDATA[<hello/>]]></Content>
            <Content type="html"><![CDATA[<world/>]]></Content>
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].content.should == "<hello/><world/>"
        end

        it "should add a hello view if only a hello view given" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html" view="hello">hello content</Content>
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].should be_nil
        end
        
        it "should add hello and world views if given 'hello,world' view" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html" view="hello,world">hello and world content</Content>        
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['hello'].content.should == "hello and world content"
          gspec.views['world'].content.should == "hello and world content"
        end

        it "should add hello and world views if given ' hello  , world  ' having spece in view name" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="html" view="  hello  ,  world  ">hello and world content</Content>        
          </Module>          
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['hello'].content.should == "hello and world content"
          gspec.views['world'].content.should == "hello and world content"
        end

        it "should work with url type" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="url" href="http://example.org/href" />
          </Module>
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].content_type.should == 'url'
          gspec.views['default'].href.should == 'http://example.org/href'
        end

        it "should work well when mix url and html content type in different view" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="url" href="http://example.org/href" view="profile"/>
            <Content type="html">html content</html>
          </Module>                 
EOS
          gspec = GadgetSpec.new(SPEC_URL, xml)
          gspec.views['default'].content_type.should == 'html'
          gspec.views['profile'].content_type.should == 'url'
        end

        it "should report conflict when given one view with both html and url type" do
          xml = <<EOS
          <Module>
            <ModulePrefs title="title" />
            <Content type="url" href="http://example.org/href" />
            <Content type="html">html content</html>
          </Module>       
EOS
          lambda{
            gspec  = GadgetSpec.new(SPEC_URL, xml)          
          }.should raise_error(GSpecParserError, "Conflict content type for view: default")
        end
      end

    end
  end
end
