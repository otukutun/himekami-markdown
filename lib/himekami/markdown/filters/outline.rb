module Himekami
  module Markdown
    module Filters
      class Outline < HTML::Pipeline::Filter
        HEADING_LEVELS = %w(h1).freeze

        def call
          doc.children.each do |node|
            next if node.is_a?(Nokogiri::XML::Element) && HEADING_LEVELS.include?(node.name)
            node.remove
          end

          doc.children.each do |node|
            br = Nokogiri::XML::Text.new "\n", @doc
            node.add_next_sibling(br)
          end

          doc
        end

      end
    end
  end
end
