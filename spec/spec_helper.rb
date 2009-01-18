require 'rubygems'
require 'spec'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'linkay'

module Linkay
  module Gadgets
    module GSpec
      SPEC_URL = "http://example.org/g.xml"      
    end
  end
end
