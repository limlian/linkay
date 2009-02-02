module Linkay
  module Gadgets
    module GSpec
      class UserPref
        attr_reader :enum_values

        def initialize(elem)
          @attributes = elem.attributes
          
          if name.nil?
            raise GSpecParserError, "UserPref's name attribute is required"
          end

          elem.children.each_with_index do |node, i|
            @enum_values = Array.new if @enum_values.nil?
            if node.attributes['default_value'].nil?
              @enum_values[i] = node.attributes['value'].to_i
            else
              @enum_values[i] = node.attributes['default_value']
            end
          end
        end

        def name
          @attributes['name']
        end
        
        def display_name
          @attributes['display_name']
        end

        def default_value
          @attributes['default_value']
        end

        def required
          if @attributes['required'] == 'true'
            return true
          else
            return false
          end
        end
        
        def datatype
          @attributes['datatype']
        end

        def urlparam
          @attributes['urlparam']
        end

        def autocomplete_url
          @attributes['autocomplete_url']
        end

        def num_minval
          @attributes['num_minval'].to_i
        end

        def num_maxval
          @attributes['num_maxval'].to_i
        end

        def str_maxlen
          @attributes['str_maxlen'].to_i
        end
        
        def restrict_to_completions
          if @attributes['restrict_to_completions'] == 'true'
            return true
          else
            return false
          end
        end

        def prefix_match
          if @attributes['prefix_match'] == 'true'
            return true
          else
            return false
          end
        end

        def publish
          if @attributes['publish'] == 'true'
            return true
          else
            return false
          end
        end

        def listen
          if @attributes['listen'] == 'true'
            return true
          else
            return false
          end
        end

        def on_change
          @attributes['on_change']
        end

        def group
          @attributes['group']
        end
      end
    end
  end
end
