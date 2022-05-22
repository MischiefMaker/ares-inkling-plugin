module AresMUSH
  module Inklings
    class EditInklingsCmd
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
       return "You're not allowed to edit other people's Inklings."
    end

    def handle
      char = Character.find_one_by_name(self.name)
      if (char.inklings == nil)
        client.emit_failure "#{self.name} does not have any Inklings. Use inklings/set to create some first!"
      else
        inklings = Hash[char.inklings]
        self.inkling_description = inklings[self.inkling_name]
          if (enactor.name == self.name)
            Utils.grab client, enactor, "inklings/set #{self.inkling_name}=#{self.inkling_description}"
          else
            Utils.grab client, enactor, "inklings/set #{self.name}=#{self.inkling_name}/#{self.inkling_description}"
          end
      end
    end

    end
  end
end
