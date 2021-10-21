module MiddlemanDatoDast
  module Nodes
    class List < Base
      def style
        @node["style"]
      end

      def tag
        config.types[type][style]["tag"]
      end
    end
  end
end
