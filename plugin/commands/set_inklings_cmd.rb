module AresMUSH
  module Gifts
    class SetGiftsCmd
      include CommandHandler

      attr_accessor :name, :gift_name, :gift_description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        if (args.arg3 == nil)
          self.name = enactor_name
          self.gift_name = titlecase_arg(args.arg1)
          self.gift_description = trim_arg(args.arg2)
        else
          self.name = titlecase_arg(args.arg1)
          self.gift_name = titlecase_arg(args.arg2)
          self.gift_description = trim_arg(args.arg3)
        end
      end

     def required_args
       [ self.name, self.gift_description, self.gift_name ]
     end

     def check_chargen_locked
       return nil if Chargen.can_manage_apps?(enactor)
       Chargen.check_chargen_locked(enactor)
     end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        gifts = model.gifts || {}
        gifts[self.gift_name] = self.gift_description
        model.update(gifts: gifts)
        client.emit_success "Gifts set for #{self.name}!"
      end
    end
  end
end
end
