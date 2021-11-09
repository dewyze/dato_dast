module DatoDast
  module Nodes
    class Generic < Base
      def tag
        @node["tag"]
      end

      def css_class
        @node["css_class"]
      end

      def wrappers
        Array.wrap(@node["wrappers"])
      end

      def meta
        @node["meta"]
      end
    end
  end
end
