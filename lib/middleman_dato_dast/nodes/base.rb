module MiddlemanDatoDast
  module Nodes
    class Base
      EMPTY = ""
      NEWLINE = "\n"

      def self.type
        name.demodulize.camelize(:lower)
      end

      def initialize(node, links = [], blocks = [], config = nil)
        @node = node
        @links = links
        @blocks = blocks
        @config = config
      end

      def config
        @config ||= MiddlemanDatoDast.configuration
      end

      def type
        @node["type"]
      end

      def children
        @node["children"]
      end

      def wrappers
        @node["wrappers"] || Array.wrap(node_config["wrappers"])
      end

      def tag
        if node_config && node_config["tag"].is_a?(Proc)
          node_config["tag"].call(proc_object)
        else
          @node["tag"] || node_config["tag"]
        end
      end

      def css_class
        if node_config && node_config["css_class"].is_a?(Proc)
          node_config["css_class"].call(proc_object)
        else
          @node["css_class"] || node_config["css_class"]
        end
      end

      def meta
        if node_config && node_config["meta"].is_a?(Proc)
          node_config["meta"].call(proc_object)
        else
          @node["meta"] || node_config["meta"]
        end
      end

      def node_config
        @node_config ||= config.types[type]
      end

      def tag_info
        {
          "tag" => tag,
          "css_class" => css_class,
          "meta" => meta,
        }
      end

      def render
        open_wrappers +
          html_tag.open +
          render_value +
          html_tag.close +
          close_wrappers
      end

      def render_value
        render_children
      end

      def render_children
        return EMPTY unless children.present?

        children.map do |child|
          Nodes.wrap(child, @links, @blocks, config).render
        end.join("\n").gsub(/\n+/, "\n")
      end

      private

      def html_tag
        @html_tag ||= HtmlTag.parse(tag_info)
      end

      def open_wrappers
        wrapper_tags.map(&:open).join("")
      end

      def close_wrappers
        wrapper_tags.reverse.map(&:close).join("")
      end

      def wrapper_tags
        @wrapper_tags ||= wrappers.map { |wrappers| HtmlTag.parse(wrappers, proc_object) }
      end

      def proc_object
        self
      end
    end
  end
end
