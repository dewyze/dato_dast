module MiddlemanDatoDast
  module Nodes
    class Span < Base
      def marks
        @node["marks"] || []
      end

      def value
        @node["value"].gsub(/\n/, "<br/>")
      end

      def wrapper_tags
        marks.map { |mark| config.marks[mark] }
      end

      def render_value
        value
      end
    end
  end
end
