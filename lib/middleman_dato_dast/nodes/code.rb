module MiddlemanDatoDast
  module Nodes
    class Code < Base
      def language
        @node["language"]
      end

      def code
        @node["code"].gsub(/\n/, "<br/>")
      end

      def render_value
        code
      end
    end
  end
end
