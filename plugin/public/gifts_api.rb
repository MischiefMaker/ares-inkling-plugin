module AresMUSH
  module Gifts

    def self.get_gifts_for_web_viewing(char, viewer)
        (char.gifts || {}).map { |name, desc| {
        name: name,
        desc: Website.format_markdown_for_html(desc)
        }}
    end

  end
end
