module AresMUSH
  module Gifts
    class SetGiftsCmd
      include CommandHandler

      attr_accessor :gifts

      def parse_args
       self.gifts = trim_arg(cmd.args)
      end

     def required_args
       [ self.gifts ]
     end

     def check_chargen_locked
       return nil if Chargen.can_manage_apps?(enactor)
       Chargen.check_chargen_locked(enactor)
     end



      def handle
	        enactor.update(gifts: self.gifts)
          client.emit_success "Gifts set!"
      end
    end
  end
end
