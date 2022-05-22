inklingmodule AresMUSH
  module Inklings
    class DeleteInklingsCmd
    include CommandHandler

     attr_accessor :name, :inkling_name, :inkling_description

     def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (args.arg2 == nil)
          self.name = enactor_name
          self.inkling_name = titlecase_arg(args.arg1)
        else
          self.name = titlecase_arg(args.arg1)
          self.inkling_name = titlecase_arg(args.arg2)
        end
    end

    def required_args
      [ self.name, self.inkling_name ]
    end

    def check_can_view
       return nil if self.name == enactor_name
       return nil if enactor.has_permission?("view_bgs")
       return "You're not allowed to edit other people's inklings."
    end

    def handle
      char = Character.find_one_by_name(self.name)
      inklings = Hash[char.inklings]
      if ( inklings.has_key?(self.inkling_name) )
        inklings.delete self.inkling_name
        char.update(inklings: inklings)
        client.emit_success "Inkling #{self.inkling_name} deleted from #{self.name}"
      else
        client.emit_failure "#{self.name} does not have an Inkling named #{self.inkling_name}"
      end
    end

    end
  end
end
