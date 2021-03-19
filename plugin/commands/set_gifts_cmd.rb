module AresMUSH
  module Gifts
    class SetGiftsCmd
      include CommandHandler

      attr_accessor :gifts, :name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (args.arg2 == nil)
          self.name = enactor_name
          self.gifts = trim_arg(args.arg1)
        else
          self.name = titlecase_arg(args.arg1)
          self.gifts = trim_arg(args.arg2)
        end
      end

     def required_args
       [ self.gifts, self.name ]
     end

     def check_chargen_locked
       return nil if Chargen.can_manage_apps?(enactor)
       Chargen.check_chargen_locked(enactor)
     end



      def handle
        char = Character.find_one_by_name(self.name)
	      char.update(gifts: self.gifts)
        client.emit_success "Gifts set for #{self.name}!"
      end
    end
  end
end
