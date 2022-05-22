$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Inklings
       include CommandHandler

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("hints", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "inklings"
       case cmd.switch
       when "set"
          return SetInklingsCmd
       when "edit"
         return EditInklingsCmd
       when "delete"
         return DeleteInklingsCmd
       else
          return InklingsCmd
       end
     end
     return nil
   end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
