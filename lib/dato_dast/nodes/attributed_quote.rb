module DatoDast
  module Nodes
    class AttributedQuote < Base
      def attribution
        @node["attribution"]
      end

      def render
        <<~HTML
          <figure>
          #{super}
          <figcaption>
          #{attribution}
          </figcaption>
          </figure>
        HTML
      end
    end
  end
end
