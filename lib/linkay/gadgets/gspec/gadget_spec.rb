module Linkay
  module Gadgets
    module GSpec

      module GSpecParserHelper
        def get_str_value_from_attr(attr)
          if attr.nil?
            return nil
          else
            return attr.value
          end
        end

        def get_num_value_from_attr(attr)
          if attr.nil?
            return nil
          else
            return attr.value.to_i
          end
        end
        
        def get_boolean_value_from_attr(attr)
          if attr.nil?
            return nil
          else
            if attr.value == "true"
              return true
            else
              return false
            end
          end
        end
      end

      #Gadget specification parse class
      class GadgetSpec
        include GSpecParserHelper

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

          if(xml.xpath('/Module/Content').length < 1)
            raise GSpecParserError, "At least 1 content is required!"
          end
            
          xml.xpath('/Module/Content').each do |elem|
            view_list = get_view_list(get_str_value_from_attr(elem.attributes['view']))
            
            view_list.each do |view|
              if @views[view].nil?
                @views[view] = View.new(view, elem, url)
              else
                unless @views[view].content_type == get_str_value_from_attr(elem.attributes['type'])
                  raise GSpecParserError, "Conflict content type for view: #{view}" 
                end
                @views[view].append_content(elem)
              end
            end
          end
        end
        
        private

        def get_view_list(view_name)
          view_list = Array.new

          if view_name.nil?
            view_list.push('default')
          else
            view_name.split(',').each do |e|
              view_list.push(e.strip)
            end
          end
          
          return view_list
        end
      end
      
      # Error for specification parse
      class GSpecParserError < RuntimeError
      end


    end
  end
end
