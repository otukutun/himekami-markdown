module Himekami
  module Markdown
    module Filters
      class Checkbox < HTML::Pipeline::Filter
        def call
          doc.search("li").each do |li|
            if List.has_checkbox?(li)
              li = List.new(li)
              li.convert!
            end
          end
          doc
        end

        class List
          LI_ATTR_CLASS = 'task-list-item'.freeze
          CHECKBOX_ATTR_CLASS = 'task-list-item-checkbox'.freeze

          CHECKBOX_OPEN = "[ ] ".freeze
          CHECKBOX_CLOSED = "[x] ".freeze

          CHECKBOX_PATTERN = /(\[ \]|\[x\])\s+/

          class << self
            def has_checkbox?(node)
              node.text.start_with?(CHECKBOX_OPEN, CHECKBOX_CLOSED)
            end
          end

          def initialize(node)
            @node = node
          end

          def convert!
            add_css_class
            text_node
            add_checkbox_html
          end

          private

          def text_node
            return @node.children.find { |node| node.name == 'p' }.children.first if @node.children.any? { |node| node.name == 'p' }
            
            @node.children.first
          end

          def add_css_class
            @node['class'] = LI_ATTR_CLASS if @node['class'].nil? || !@node['class'].include?(LI_ATTR_CLASS)
          end

          def remove_md
            text_node.content = text_node.content.sub(CHECKBOX_PATTERN, '').strip
          end

          def add_checkbox_html
            html = open_checkbox? ? render_open_checkbox_html : render_closed_checkbox_html

            remove_md
            text_node.add_previous_sibling(html)
          end

          def render_open_checkbox_html
            '<input type="checkbox" class="task-list-item-checkbox" disabled="true"/>'
          end

          def render_closed_checkbox_html
            '<input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="true"/>'
          end

          def open_checkbox?
            text_node.content.start_with?(CHECKBOX_OPEN)
          end
        end
      end
    end
  end
end
