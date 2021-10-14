module MiddlemanDatoDast
  module Nodes
    class Span < Base
      def tag
        @tag ||= config.node_tags[type]
      end

      def marks
        @node["marks"]
      end

      def value
        @node["value"].gsub(/\n/, "<br/>")
      end

      def mark_tags
        # TODO: Warn if tag is not present
        return [] unless marks.present?

        @mark_tags ||= marks.map { |mark| config.mark_tags[mark] }
      end

      def render(depth = 0)
        prefixes = []
        suffixes = []

        mark_tags.each do |tag|
          prefixes.append("<#{tag}>")
          suffixes.prepend("</#{tag}>")
        end


        "#{prefixes.join("")}#{value}#{suffixes.join("")}"
      end
    end
  end
end
