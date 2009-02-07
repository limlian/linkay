module Linkay
  module Gadgets
    module GSpec
      class UserPref
        include GSpecParserHelper

        attr_reader :enum_values

        def initialize(elem)
          @attributes = elem.attributes
          
          if name.nil?
            raise GSpecParserError, "UserPref's name attribute is required"
          end

          elem.children.each do |node|
            if node.elem? 
              @enum_values = Array.new if @enum_values.nil?
              if node.attributes['default_value'].nil?
                @enum_values.push get_num_value_from_attr(node.attributes['value'])
              else
                @enum_values.push get_str_value_from_attr(node.attributes['default_value'])
              end
            end
          end
        end

        def name
          get_str_value_from_attr(@attributes['name'])
        end
        
        def display_name
          @attributes['display_name'].value
        end

        def default_value
          @attributes['default_value'].value
        end

        def required
          if @attributes['required'].value == 'true'
            return true
          else
            return false
          end
        end
        
        def datatype
          @attributes['datatype'].value
        end

        def urlparam
          @attributes['urlparam'].value
        end

        def autocomplete_url
          @attributes['autocomplete_url'].value
        end

        def num_minval
          @attributes['num_minval'].value.to_i
        end

        def num_maxval
          @attributes['num_maxval'].value.to_i
        end

        def str_maxlen
          @attributes['str_maxlen'].value.to_i
        end
        
        def restrict_to_completions
          if @attributes['restrict_to_completions'].value == 'true'
            return true
          else
            return false
          end
        end

        def prefix_match
          if @attributes['prefix_match'].value == 'true'
            return true
          else
            return false
          end
        end

        def publish
          if @attributes['publish'].value == 'true'
            return true
          else
            return false
          end
        end

        def listen
          if @attributes['listen'].value == 'true'
            return true
          else
            return false
          end
        end

        def on_change
          @attributes['on_change'].value
        end

        def group
          @attributes['group'].value
        end
      end
    end
  end
end
