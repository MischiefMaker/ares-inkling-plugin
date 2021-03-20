module AresMUSH
  module Gifts
    class GiftsTemplate < ErbTemplateRenderer
      attr_accessor :char, :gifts

      def initialize(char, gifts)
        @char = char
        @gifts = Hash[gifts]
        super File.dirname(__FILE__) + "/GiftsTemplate.erb"
      end
      def military_name(char)
        Ranks.military_name(char)
      end
      def prism_color(char)
        char.groups[:prism]
      end
    end
  end
end
