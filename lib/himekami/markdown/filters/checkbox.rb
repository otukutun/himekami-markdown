module Himekami
  module Markdown
    module Filters
      class Checkbox < HTML::Pipeline::Filter
        def call
          doc.search("li").each do |li|

            list = List.new(li) if List.has_checkbox?(li)
            list.convert!
          end
          doc
        end

        class List
          LI_ATTR_CLASS = 'task-list-item'.freeze
          CHECKBOX_ATTR_CLASS = 'task-list-item-checkbox'.freeze

          CHECKBOX_OPEN = "[ ]".freeze
          CHECKBOX_CLOSED = "[x]".freeze

          CHECKBOX_OPEN_PATTERN = /\[ \]/
          CHECKBOX_CLOSED_PATTERN = /\[x\]/
          CHECKBOX_PATTERN = /(#{CHECKBOX_OPEN_PATTERN}|#{CHECKBOX_CLOSED_PATTERN})/

          class << self
            def has_checkbox?(node)
              node.text =~ CHECKBOX_PATTERN
            end
          end

          def initialize(node)
            @node = node
          end

          def convert!
            add_css_class
            add_checkbox_html
          end

          private

          def add_css_class
            @node['class'] = LI_ATTR_CLASS if @node['class'].nil? || !@node['class'].include?(LI_ATTR_CLASS)
          end

          def remove_md
            @node.children.first.content = @node.children.first.content.sub(CHECKBOX_PATTERN, '').strip
          end

          def add_checkbox_html
            html = open_checkbox? ? render_open_checkbox_html : render_closed_checkbox_html

            remove_md
            @node.children.first.add_previous_sibling(html)
          end

          def render_open_checkbox_html
            '<input type="checkbox" class="task-list-item-checkbox" />'
          end

          def render_closed_checkbox_html
            '<input type="checkbox" class="task-list-item-checkbox" checked="true" />'
          end

          def open_checkbox?
            @node.children.first.content.include?(CHECKBOX_OPEN)
          end
        end
      end
    end
  end
end
