module Linkay
  module Gadgets
    module GSpec
      class View
        attr_reader :name, :content

        def initialize(key, elem, url)
          @name = key
          @attributes = elem.attributes
          @content = elem.content
        end

        def content_type
          @attributes['type']
        end

        def preferred_height
          @attributes['preferred_height'].to_i
        end

        def preferred_width
          @attributes['preferred_width'].to_i
        end

        def href
          @attributes['href']
        end

        def append_content(elem)
          @content = @content + elem.content
        end
      end
    end
  end
end
