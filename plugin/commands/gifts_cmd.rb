module AresMUSH
  module Inklings
    class InklingsCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end


      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = InklingsTemplate.new(model,model.inklings || {})
          client.emit template.render
	       end
      end
    end
  end
end
