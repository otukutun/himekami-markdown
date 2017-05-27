module Himekami
  module Markdown
    class Processor
      class << self
        def default_context
          {
            asset_root: "/images",
          }
        end

        def default_filters
          [
          ]
        end
      end

      def initialize(context = {})
        @context = self.class.default_context.merge(context)
      end

      def call(input, context = {})
        HTML::Pipeline.new(filters, @context).call(input, context)
      end

      def filters
        @filters ||= self.class.default_filters
      end
    end
  end
end
