module AresMUSH
  module Inklings
    class InklingsTemplate < ErbTemplateRenderer
      attr_accessor :char, :inklings

      def initialize(char, inklings)
        @char = char
        @inklings = Hash[inklings]
        super File.dirname(__FILE__) + "/InklingsTemplate.erb"
      end
      def military_name(char)
        Ranks.military_name(char)
      end
    end
  end
end
