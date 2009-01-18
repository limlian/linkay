module Linkay
  module Gadgets
    module GSpec

      #Gadget specification parse class
      class GadgetSpec
        attr_reader :url, :modulePrefs, :userPrefs, :views
        
        def initialize(url, xml_str)
          @userPrefs = Array.new
          @views = Hash.new
          @url = url

          xml = Nokogiri::XML(xml_str)

          if(xml.xpath('/Module/ModulePrefs').length != 1)
            raise GSpecParserError, "Exactly 1 ModulePrefs is required!"
          else
            @modulePrefs = ModulePrefs.new(xml.xpath('/Module/ModulePrefs')[0], url)
          end

          xml.xpath('/Module/UserPref').each{|elem| @userPrefs.push(UserPref.new(elem))}
          @views['default'] = View.new('default', xml.xpath('/Module/Content')[0], url)      
        end
      end
      
      # Error for specification parse
      class GSpecParserError < RuntimeError
      end

    end
  end
end
