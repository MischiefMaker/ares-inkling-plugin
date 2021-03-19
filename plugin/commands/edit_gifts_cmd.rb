module AresMUSH
  module Gifts
    class EditGiftsCmd
    include CommandHandler

     attr_accessor :name, :gifts

     def parse_args
          self.name = cmd.args || enactor_name
    end

    def check_can_view
       return nil if self.name == enactor_name
       return nil if enactor.has_permission?("view_bgs")
       return "You're not allowed to edit other people's gifts."
    end

    def handle
      if (enactor.name == self.name)
        Utils.grab client, enactor, "gifts/set #{enactor.gifts}"
      else
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          Utils.grab client, enactor, "gifts/set #{model.name}=#{model.gifts}"
          end
      end
    end

    end
  end
end
