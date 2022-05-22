module AresMUSH
  module Inklings

    def self.get_inklings_for_web_viewing(char, viewer)
        (char.inklings || {}).map { |name, desc| {
        name: name,
        desc: Website.format_markdown_for_html(desc)
        }}
    end

    def self.get_inklings_for_web_editing(char)
        (char.inklings || {}).map { |name, desc| {
        name: name,
        desc: Website.format_input_for_html(desc)
        }}
    end

    def self.save_inklings_from_chargen(char, chargen_data)
      inklings = chargen_data[:custom] || {}
      inklings.each do |name, desc|
        inklings[name.titlecase] = Website.format_input_for_mush(desc)
      end
      char.update(inklings: inklings)
      return []
    end

    def self.get_blurb_for_web()
     blurb = Global.read_config('inklings')["inklings_blurb"]
     Website.format_input_for_html(blurb)
    end

    def self.check_inklings_for_chargen(char)
      inklings = char.inklings || {}
      if (inklings.empty?())
        msg = t('chargen.oops_missing', :missing => "Inklings")
      else
        msg = t('chargen.ok')
      end

      return Chargen.format_review_status "Checking Inklings are set.", msg
    end

  end
end
