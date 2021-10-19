module MiddlemanDatoDast
  module Nodes
    class Heading < Base
      def level
        @node["level"]
      end

      def tag
        base_tag = MiddlemanDatoDast.configuration.node_tags[type]
        @tag = base_tag.gsub(/#/, level.to_s)
      end
    end
  end
end
