module MiddlemanDatoDast
  module Nodes
    class Blockquote < Base
      ATTRIBUTION = "attribution"

      def attribution
        @node["attribution"]
      end

      def attribution_tag
        config.other_tags[ATTRIBUTION]
      end

      def render
        <<~HTML
          <#{wrapper_tag}>
            <#{tag}>
              #{render_children}
            </#{tag}>
            <#{attribution_tag}>#{attribution}</#{attribution_tag}>
          </#{wrapper_tag}>
        HTML
      end
    end
  end
end
