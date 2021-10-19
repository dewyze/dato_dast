module MiddlemanDatoDast
  module Nodes
    class Base
      include NodeUtils

      EMPTY = ""
      NEWLINE = "\n"
      SPACING = "  ".freeze

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

      def wrapper_tags
        Array(config.wrapper_tags[type])
      end

      def tag
        config.node_tags[type]
      end

      def classes
        # TODO
      end

      def open
        return "" unless tag

        "<#{tag}>" + NEWLINE
      end

      def close
        return "" unless tag

        NEWLINE + "</#{tag}>"
      end

      def render
        html = ""
        if wrapper_tags.present?
          opening = ""
          closing = ""
          wrapper_tags.each_with_index do |wrapper_tag, index|
            opening += "<#{wrapper_tag}>" + NEWLINE
            closing = NEWLINE + "</#{wrapper_tag}>" + closing
          end
          html += opening + open
          html += render_value
          html += close + closing
        else
          html += open
          html += render_value
          html + close
        end
      end

      def render_value
        render_children
      end

      def render_children
        return "" unless children.present?

        html = children.map do |child|
          wrap(child).render
        end.join("\n").gsub(/\n+/, "\n")
      end
    end
  end
end
