module MiddlemanDatoDast
  module Nodes
    class Heading < Base
      def level
        @node["level"]
      end

      def tag
        base_tag = MiddlemanDatoDast.configuration.types[type]["tag"]
        @tag = base_tag.gsub(/#/, level.to_s)
      end
    end
  end
end
