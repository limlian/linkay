module Linkay
  module Gadgets
    module GSpec
      class ModulePrefs
        attr_reader :url
        
        def initialize(elem, url)
          @url = url
          @attributes = elem.attributes
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
      end
    end
  end
end
