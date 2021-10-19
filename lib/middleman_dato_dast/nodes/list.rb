module MiddlemanDatoDast
  module Nodes
    class List < Base
      def style
        @node["style"]
      end

      def tag
        @tag ||= config.node_tags[type][style]
      end
    end
  end
end
