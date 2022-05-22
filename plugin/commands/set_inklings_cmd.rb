module AresMUSH
  module Inklings
    class SetInklingsCmd
      include CommandHandler

      attr_accessor :name, :inkling_name, :inkling_description

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        if (args.arg3 == nil)
          self.name = enactor_name
          self.inkling_name = titlecase_arg(args.arg1)
          self.inkling_description = trim_arg(args.arg2)
        else
          self.name = titlecase_arg(args.arg1)
          self.inkling_name = titlecase_arg(args.arg2)
          self.inkling_description = trim_arg(args.arg3)
        end
      end

     def required_args
       [ self.name, self.inkling_description, self.inkling_name ]
     end

     def check_chargen_locked
       return nil if Chargen.can_manage_apps?(enactor)
       Chargen.check_chargen_locked(enactor)
     end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        inklings = model.inklings || {}
        inklings[self.inkling_name] = self.inkling_description
        model.update(inklings: inklings)
        client.emit_success "Inkling set for #{self.name}!"
      end
    end
  end
end
end
