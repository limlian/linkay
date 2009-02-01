module Linkay
  module Gadgets
    module GSpec
      class ModulePrefs
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
          @attributes['title']
        end

        def title_url
          @attributes['title_url']
        end

        def description
          @attributes['description']
        end

        def author
          @attributes['author']
        end

        def author_email
          @attributes['author_email']
        end

        def screenshot
         @attributes['screenshot']
        end

        def thumbnail
          @attributes['thumbnail']
        end

        def directory_title
          @attributes['directory_title']
        end

        def width
          @attributes['width'].to_i
        end

        def height
          @attributes['height'].to_i
        end

        def scrolling
          if @attributes['scrolling'] == "true"
            return true
          else
            return false
          end
        end

        def categories
          cats = ["",""]
          cats[0] = @attributes["category"] unless @attributes["category"].nil?
          cats[1] = @attributes["category2"] unless @attributes["category2"].nil?
          return cats
        end

        def author_affiliation
          @attributes['author_affiliation']
        end

        def author_location
          @attributes['author_location']
        end

        def author_photo
          @attributes['author_photo']
        end

        def author_aboutme
          @attributes['author_aboutme']
        end

        def author_quote
          @attributes['author_quote']
        end

        def author_link
          @attributes['author_link']
        end

        def show_stats
          if @attributes['show_stats'] == 'true'
            return true
          else
            return false
          end
        end

        def show_in_directory
          if @attributes['show_in_directory'] == 'true'
            return true
          else
            return false
          end
        end

        def singleton
          if @attributes['singleton'] == 'true'
            return true
          else
            return false
          end
        end
        
        private 

        def create_feature(node)
          @features = Hash.new if @features.nil?
          @features[node.attributes["feature"]] = Feature.new(node)
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
        attr_reader :name, :params
        
        def initialize(node)
          @name = node.attributes['feature']
          if node.name == "Require" then
            @require = true
          else
            @require = false
          end          
          @params = Hash.new
          node.children.each {|node|
            @params[node.attributes["name"]] = node.content
          }
        end

        def is_required?
          @require
        end
      end

      class Icon
        attr_reader :type, :mode, :content
        
        def initialize(node)
          @type = node.attributes["type"]
          @mode = node.attributes["mode"]
          @content = node.content
        end
      end

      class Link
        attr_reader :href, :rel
        
        def initialize(node)
          @href = node.attributes["href"]
          @rel = node.attributes["rel"]
        end
      end
      
      class Preload
        attr_reader :href, :authz
        
        def initialize(node)
          @href = node.attributes["href"]
          @authz = node.attributes["authz"]
        end
      end

      class OAuth
        attr_reader :services

        def initialize(node)
          @services = Hash.new
          node.xpath("//Service").to_ary.each do |s| 
            @services[s.attributes["name"]] = Service.new(s)
          end
        end
      end

      class Service
        attr_reader :request, :access, :authorization

        def initialize(node)
          request_node = node.xpath("//Request")[0]
          unless request_node.nil? 
            @request = Hash.new
            @request["url"] = request_node.attributes["url"]
            @request["param_location"] = request_node.attributes["param_location"]
            @request["method"] = request_node.attributes["method"]
          end
          access_node = node.xpath("//Access")[0]
          unless access_node.nil?
            @access = Hash.new
            @access["url"] = access_node.attributes["url"]
            @access["param_location"] = access_node.attributes["param_location"]
            @access["method"] = access_node.attributes["method"]
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
