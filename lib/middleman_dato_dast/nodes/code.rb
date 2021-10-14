module MiddlemanDatoDast
  module Nodes
    class Code < Base
      def language
        # TODO: Use this

        @node["language"]
      end

      def code
        @node["code"].gsub(/\n/, "<br/>")
      end

      def render
        <<~HTML.strip
          <#{wrapper_tag}>
            <#{tag}>#{code}</#{tag}>
          </#{wrapper_tag}>
        HTML

      end
    end
  end
end
