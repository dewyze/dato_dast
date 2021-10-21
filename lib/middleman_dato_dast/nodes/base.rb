module MiddlemanDatoDast
  module Nodes
    class Base
      EMPTY = ""
      NEWLINE = "\n"

      def self.type
        name.demodulize.camelize(:lower)
      end

      def initialize(node, links = [], blocks = [])
        @node = node
        @links = links
        @blocks = blocks
      end

      def config
        MiddlemanDatoDast.configuration
      end

      def type
        @node["type"]
      end

      def children
        @node["children"]
      end

      def wrappers
        @node["wrappers"] || Array(config.types[type]["wrappers"])
      end

      def tag
        @node["tag"] || config.types[type]["tag"]
      end

      def css_class
        @node["css_class"] || config.types[type]["css_class"]
      end

      def meta
        @node["meta"] || config.types[type]["meta"]
      end

      def tag_info
        {
          "tag" => tag,
          "css_class" => css_class,
          "meta" => meta,
        }
      end

      def render
        open_wrappers +
          html_tag.open +
          render_value +
          html_tag.close +
          close_wrappers
      end

      def render_value
        render_children
      end

      def render_children
        return EMPTY unless children.present?

        children.map do |child|
          Nodes.wrap(child, @links, @blocks).render
        end.join("\n").gsub(/\n+/, "\n")
      end

      private

      def html_tag
        @html_tag ||= HtmlTag.parse(tag_info)
      end

      def open_wrappers
        wrapper_tags.map(&:open).join("")
      end

      def close_wrappers
        wrapper_tags.reverse.map(&:close).join("")
      end

      def wrapper_tags
        @wrapper_tags ||= wrappers.map { |wrappers| HtmlTag.parse(wrappers) }
      end
    end
  end
end
