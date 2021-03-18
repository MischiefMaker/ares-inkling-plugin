module AresMUSH

  module Gifts
    class EditGiftsCmd
      include CommandHandler

      attr_accessor :name, :gifts

      def parse_args
        self.name = enactor_name
      end


      def handle
        AnyTargetFinder.with_any_name_or_id(self.name, client, enactor) do |model|
          gifts = model.gifts
          Utils.grab client, enactor, "gifts/set #{gifts}"
        end
      end

    end
  end
end
