module MiddlemanDatoDast
  module Nodes
    class List < Base
      def style
        @node["style"]
      end

      def tag
        @tag ||= config.types[type]["tag"][style]
      end
    end
  end
end
