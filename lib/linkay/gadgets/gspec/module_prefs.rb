module Linkay
  module Gadgets
    module GSpec
      class ModulePrefs
        include GSpecParserHelper

        attr_reader :url, :features, :icon, :links, :preloads, :oauth
        
        def initialize(elem, url)
          @url = url          
          @attributes = elem.attributes

          if title.nil?
            raise GSpecParserError, "Modulepref's title attribute is required"
          end

          elem.children.each do |node|
            case node.name
            when "Require"
              create_feature node
            when "Optional"
              create_feature node
            when "Icon"
              create_icon node
            when "Link"
              create_link node
            when "Preload"
              create_preload node
            when "OAuth"
              create_oauth node
            end
          end
        end

        def title
          get_str_value_from_attr @attributes['title']
        end

        def title_url
          get_str_value_from_attr @attributes['title_url']
        end

        def description
          get_str_value_from_attr @attributes['description']
        end

        def author
          get_str_value_from_attr @attributes['author']
        end

        def author_email
          get_str_value_from_attr @attributes['author_email']
        end

        def screenshot
          get_str_value_from_attr @attributes['screenshot']
        end

        def thumbnail
          get_str_value_from_attr @attributes['thumbnail']
        end

        def directory_title
          get_str_value_from_attr @attributes['directory_title']
        end

        def width
          get_num_value_from_attr @attributes['width']
        end

        def height
          get_num_value_from_attr @attributes['height']
        end

        def scrolling
          get_boolean_value_from_attr @attributes['scrolling'] 
        end

        def categories
          cats = ["",""]
          cats[0] = get_str_value_from_attr(@attributes["category"]) unless @attributes["category"].nil?
          cats[1] = get_str_value_from_attr(@attributes["category2"]) unless @attributes["category2"].nil?
          return cats
        end

        def author_affiliation
          get_str_value_from_attr @attributes['author_affiliation']
        end

        def author_location
          get_str_value_from_attr @attributes['author_location']
        end

        def author_photo
          get_str_value_from_attr @attributes['author_photo']
        end

        def author_aboutme
          get_str_value_from_attr @attributes['author_aboutme']
        end

        def author_quote
          get_str_value_from_attr @attributes['author_quote']
        end

        def author_link
          get_str_value_from_attr @attributes['author_link']
        end

        def show_stats
          get_boolean_value_from_attr @attributes['show_stats']
        end

        def show_in_directory
          get_boolean_value_from_attr @attributes['show_in_directory']
        end

        def singleton
          get_boolean_value_from_attr @attributes['singleton']
        end
        
        private 

        def create_feature(node)
          @features = Hash.new if @features.nil?
          @features[get_str_value_from_attr(node.attributes["feature"])] = Feature.new(node)
        end        

        def create_icon(node)
          @icon = Icon.new(node)
        end

        def create_link(node)
          @links = Array.new if @links.nil?
          @links.push Link.new(node)
        end

        def create_preload(node)
          @preloads = Array.new if @preloads.nil?
          @preloads.push Preload.new(node)
        end

        def create_oauth(node)
          @oauth = OAuth.new(node)
        end
      end

      class Feature
        include GSpecParserHelper

        attr_reader :name, :params
        
        def initialize(node)
          @name = get_str_value_from_attr(node.attributes['feature'])
          if node.name == "Require" then
            @require = true
          else
            @require = false
          end          
          @params = Hash.new
          node.children.each {|node|
            if node.elem?
              @params[get_str_value_from_attr(node.attributes["name"])] = node.content
            end
          }
        end

        def is_required?
          @require
        end
      end

      class Icon
        include GSpecParserHelper

        attr_reader :type, :mode, :content
        
        def initialize(node)
          @type = get_str_value_from_attr(node.attributes["type"])
          @mode = get_str_value_from_attr(node.attributes["mode"])
          @content = node.content
        end
      end

      class Link
        include GSpecParserHelper

        attr_reader :href, :rel
        
        def initialize(node)
          @href = get_str_value_from_attr(node.attributes["href"])
          @rel = get_str_value_from_attr(node.attributes["rel"])
        end
      end
      
      class Preload
        include GSpecParserHelper

        attr_reader :href, :authz
        
        def initialize(node)
          @href = get_str_value_from_attr(node.attributes["href"])
          @authz = get_str_value_from_attr(node.attributes["authz"])
        end
      end

      class OAuth
        include GSpecParserHelper

        attr_reader :services

        def initialize(node)
          @services = Hash.new
          node.xpath("//Service").to_ary.each do |s| 
            @services[get_str_value_from_attr(s.attributes["name"])] = Service.new(s)
          end
        end
      end

      class Service
        include GSpecParserHelper
        attr_reader :request, :access, :authorization

        def initialize(node)
          request_node = node.xpath("//Request")[0]
          unless request_node.nil? 
            @request = Hash.new
            @request["url"] = get_str_value_from_attr(request_node.attributes["url"])
            @request["param_location"] = get_str_value_from_attr(request_node.attributes["param_location"])
            @request["method"] = get_str_value_from_attr(request_node.attributes["method"])
          end
          access_node = node.xpath("//Access")[0]
          unless access_node.nil?
            @access = Hash.new
            @access["url"] = get_str_value_from_attr(access_node.attributes["url"])
            @access["param_location"] = get_str_value_from_attr(access_node.attributes["param_location"])
            @access["method"] = get_str_value_from_attr(access_node.attributes["method"])
          end
          authorization_node = node.xpath("//Authorization")[0]
          unless authorization_node.nil?
            @authorization = Hash.new
            @authorization["url"] = authorization_node["url"]
          end
        end
      end

    end
  end
end
