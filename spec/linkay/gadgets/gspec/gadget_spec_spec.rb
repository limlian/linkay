require File.dirname(__FILE__) + '/../../../spec_helper'

module Linkay
  module Gadgets
    module GSpec
      describe GadgetSpec do
        it "should return world calling hello" do
          g = GadgetSpec.new
          g.hello.should == 'world'
        end
      end
    end
  end
end
