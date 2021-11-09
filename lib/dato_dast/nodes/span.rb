module DatoDast
  module Nodes
    class Span < Base
      def marks
        @node["marks"] || []
      end

      def value
        @node["value"].gsub(/\n/, "<br/>")
      end

      def wrappers
        Array.wrap(super) + marks.map { |mark| config.marks[mark] }
      end

      def render_value
        value
      end
    end
  end
end
