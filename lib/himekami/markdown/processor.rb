module Himekami
  module Markdown
    class Processor < BaseProcessor
      class << self
        def default_context
          {
            asset_root: "/images",
          }
        end

        def default_filters
          [
            HTML::Pipeline::MarkdownFilter,
            HTML::Pipeline::SyntaxHighlightFilter,
            Filters::Checkbox,
          ]
        end
      end
    end
  end
end
