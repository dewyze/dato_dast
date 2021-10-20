module MiddlemanDatoDast
  module Nodes
    class Base
      include NodeUtils

      EMPTY = ""
      NEWLINE = "\n"

      def self.type
        name.demodulize.camelize(:lower)
      end

      def initialize(node)
        @node = node
      end

      def type
        @node["type"]
      end

      def children
        @node["children"]
      end

      def tag
        config.types[type]["tag"]
      end

      def open_tag
        return EMPTY unless tag

        "<#{tag}>" + NEWLINE
      end

      def close_tag
        return EMPTY unless tag

        NEWLINE + "</#{tag}>"
      end

      def wrapper_tags
        @node["wrapper_tags"] || Array(config.types[type]["wrappers"])
      end

      def wrappers
        @wrappers ||= wrapper_tags.map { |wrapper_tag| HtmlTag.parse(wrapper_tag) }
      end

      def css_class
        @css_class ||= @node["css_class"] || config.types[type]["css_class"]
      end

      def render
        html = open_tag + render_value + close_tag

        wrappers.map(&:open).join("") + html + wrappers.reverse.map(&:close).join("")
      end

      def render_value
        render_children
      end

      def render_children
        return EMPTY unless children.present?

        children.map do |child|
          wrap(child).render
        end.join("\n").gsub(/\n+/, "\n")
      end
    end
  end
end
