module Himekami
  module Markdown
    class OutlineProcessor < BaseProcessor
      class << self
        def default_context
          {
            asset_root: "/images"
          }
        end

        def default_filters
          [
            HTML::Pipeline::MarkdownFilter,
            Filters::Outline,
          ]
        end
      end
    end
  end
end
