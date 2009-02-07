module Linkay
  module Gadgets
    module GSpec
      class View
        include GSpecParserHelper

        attr_reader :name, :content

        def initialize(key, elem, url)
          @name = key
          @attributes = elem.attributes
          @content = elem.content
        end

        def content_type
          get_str_value_from_attr @attributes['type']
        end

        def preferred_height
          get_num_value_from_attr @attributes['preferred_height']
        end

        def preferred_width
          get_num_value_from_attr @attributes['preferred_width']
        end

        def href
          get_str_value_from_attr @attributes['href']
        end

        def append_content(elem)
          @content = @content + elem.content
        end
      end
    end
  end
end
