module MiddlemanDatoDast
  module Nodes
    class Generic < Base
      def tag
        @node["tag"]
      end

      def wrapper_tags
        @node["wrapper_tags"]
      end
    end
  end
end
