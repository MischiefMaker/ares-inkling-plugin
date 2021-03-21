module AresMUSH
  module Gifts
    class DeleteGiftsCmd
    include CommandHandler

     attr_accessor :name, :gift_name, :gift_description

     def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (args.arg2 == nil)
          self.name = enactor_name
          self.gift_name = titlecase_arg(args.arg1)
        else
          self.name = titlecase_arg(args.arg1)
          self.gift_name = titlecase_arg(args.arg2)
        end
    end

    def required_args
      [ self.name, self.gift_name ]
    end

    def check_can_view
       return nil if self.name == enactor_name
       return nil if enactor.has_permission?("view_bgs")
       return "You're not allowed to edit other people's gifts."
    end

    def handle
      char = Character.find_one_by_name(self.name)
      gifts = Hash[char.gifts]
      if ( gifts.has_key?(self.gift_name) )
        gifts.delete self.gift_name
        char.update(gifts: gifts)
        client.emit_success "Gift #{self.gift_name} deleted from #{self.name}"
      else
        client.emit_failure "#{self.name} does not have a Gift named #{self.gift_name}"
      end
    end

    end
  end
end
