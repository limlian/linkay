require File.dirname(__FILE__) + '/../../../spec_helper'

module Linkay
  module Gadgets
    module GSpec
      
      describe ModulePrefs do
        it "should parse module prefs node well" do
          full_module_prefs = <<EOS
<ModulePrefs
  title='title'
  title_url='title_url'
  description='description'
  author='author'
  author_email='author_email'
  screenshot='screenshot'
  thumbnail='thumbnail'
  directory_title='directory_title'
  width='1'
  height='2'
  scrolling='true'
  category='category'
  category2='category2'
  author_affiliation='author_affiliation'
  author_location='author_location'
  author_photo='author_photo'
  author_aboutme='author_aboutme'
  author_quote='author_quote'
  author_link='author_link'
  show_stats='true'
  show_in_directory='true'
  singleton='true'>
    <Require feature='require'/>
    <Optional feature='optional'/>
    <Preload href='http://example.org' authz='signed'/>
    <Icon/>
    <Locale/>
    <Link rel='link' href='http://example.org/link'/>
    <OAuth>
      <Service name='serviceOne'>
        <Request url='http://www.example.com/request'
                 method='GET' param_location='auth-header' />
          <Authorization url='http://www.example.com/authorize'/>
          <Access url='http://www.example.com/access' method='GET'
                 param_location='auth-header' />
       </Service>
    </OAuth>
</ModulePrefs>     
EOS
          mps = ModulePrefs.new(Nokogiri::XML(full_module_prefs).root, SPEC_URL)
          mps.url.should == SPEC_URL
          mps.title.should == 'title'
          mps.title_url.should == 'title_url'
          mps.description.should == 'description'
          mps.author.should == 'author'
          mps.author_email.should == 'author_email'
          mps.screenshot.should == 'screenshot'
          mps.thumbnail.should == 'thumbnail'
          mps.directory_title.should == 'directory_title'
          mps.width.should == 1
          mps.height.should == 2
          mps.scrolling.should be_true
          mps.categories[0].should == 'category'
          mps.categories[1].should == 'category2'
          mps.author_affiliation.should == 'author_affiliation'
          mps.author_location.should == 'author_location'
          mps.author_photo.should == 'author_photo'
          mps.author_aboutme.should == 'author_aboutme'
          mps.author_quote.should == 'author_quote'
          mps.author_link.should == 'author_link'
          mps.show_stats.should be_true
          mps.show_in_directory.should be_true
          mps.singleton.should be_true
          mps.features.should_not be_nil
        end

        it "should raise exception when missing title attribute" do
          missing_title_xml = <<EOS
            <ModulePrefs />
EOS
          lambda {
            mps = ModulePrefs.new(Nokogiri::XML(missing_title_xml).root, SPEC_URL)
          }.should raise_error(GSpecParserError, "Modulepref's title attribute is required")
        end
        
        it "should parse module prefs correctly with title attribute" do
          double_moduleprefs_title_xml = <<EOS
          <ModulePrefs
            title="title1"
            title="title2"/>          
EOS
          mps = ModulePrefs.new(Nokogiri::XML(double_moduleprefs_title_xml).root, SPEC_URL)
          mps.title.should == "title1"
        end

        it "should parse module prefs correctly with scrolling attribute" do
          scrolling_true_xml = <<EOS
          <ModulePrefs
            title="title"
            scrolling="true"/>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(scrolling_true_xml).root, SPEC_URL)
          mps.scrolling.should be_true

          scrolling_false_xml = <<EOS
          <ModulePrefs
            title="title"
            scrolling="false"/>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(scrolling_false_xml).root, SPEC_URL)
          mps.scrolling.should be_false

          scrolling_not_so_true_xml = <<EOS
          <ModulePrefs
            title="title"
            scrolling="not_so_true"/>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(scrolling_not_so_true_xml).root, SPEC_URL)
          mps.scrolling.should be_false
        end

        it "should parse module prefs correctly with category attributes" do
          category_xml = <<EOS
            <ModulePrefs
              title="title"
              category="category1"/>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(category_xml).root, SPEC_URL)
          mps.categories.should == ["category1",""]

          two_categories_xml = <<EOS
            <ModulePrefs
              title="title"
              category="category1"
              category2="category2" />
EOS
          mps = ModulePrefs.new(Nokogiri::XML(two_categories_xml).root, SPEC_URL)
          mps.categories.should == ["category1", "category2"]

          none_categories_xml = <<EOS
            <ModulePrefs
               title="title"/>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(none_categories_xml).root, SPEC_URL)
          mps.categories.should == ["", ""]
        end

        it "should parse module prefs correctly with features sub tags" do
          xml = <<EOS
          <ModulePrefs
               title="title">
            <Require feature='require'/>
            <Optional feature='optional'/>
          </ModulePrefs>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(xml).root, SPEC_URL)
          mps.features.should be_an_instance_of(Hash)
          mps.features.has_key?("require").should be_true
          mps.features.has_key?("optional").should be_true
          mps.features["require"].should be_an_instance_of(Feature)
          mps.features["require"].name.should == "require"
          mps.features["require"].is_required?.should be_true
          mps.features["optional"].should be_an_instance_of(Feature)
          mps.features["optional"].name.should == "optional"
          mps.features["optional"].is_required?.should be_false
        end

        it "should parse module prefs correctly with features with parameters" do
          xml = <<EOS
          <ModulePrefs
               title="title">
            <Require feature='my_feature'>
              <Param name='my_param1'>my_value1</Param>
              <Param name='my_param2'>my_value2</Param>
            </Require>
          </ModulePrefs>
EOS
          mps = ModulePrefs.new(Nokogiri::XML(xml).root, SPEC_URL)
          mps.features["my_feature"].should be_an_instance_of(Feature)
          mps.features["my_feature"].name.should == "my_feature"
          mps.features["my_feature"].params.should be_an_instance_of(Hash)
          mps.features["my_feature"].params["my_param1"].should == "my_value1"
          mps.features["my_feature"].params["my_param2"].should == "my_value2"
        end
      end
    end
  end
end
