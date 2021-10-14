module MiddlemanDatoDast
  module Nodes
    class Base
      include NodeUtils

      def self.type
        name.demodulize.camelize(:lower)
      end

      def initialize(node)
        @node = node
      end

      def type
        @node["type"]
      end

      def children
        @node["children"]
      end

      def whitespace
        return false if config.minify

        config.whitespace[type]
      end

      def wrapper_tag
        config.wrapper_tags[type]
      end

      def tag
        config.node_tags[type]
      end

      def render
        raise NotImplementedError
      end

      def classes
        # TODO
      end

      def open
        "<#{tag}>"
      end

      def close
        "</#{tag}>"
      end

      def render
        "#{open}#{render_children}#{close}\n"
      end

      def render_children
        return "" unless children.present?

        children.map do |child|
          wrap(child).render
        end.join("").strip
      end
    end
  end
end
