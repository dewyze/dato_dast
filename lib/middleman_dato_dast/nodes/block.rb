module MiddlemanDatoDast
  module Nodes
    class Block < Base
      def block_id
        @node["item"]
      end

      def block
        @blocks.find { |block| block[:id] == block_id }
      end

      def item_type
        block[:item_type]
      end

      def node
        node_config["node"]
      end

      def node_config
        config.blocks[item_type]
      end

      def children
        Array.wrap(structure).map do |child|
          case child["type"]
          when "field"
            build_field(child)
          when "value"
            build_value(child)
          when "block"
            build_block(block[child["field"].to_sym])
          when "blocks"
            build_blocks(child)
          else
            raise "BOOM" # TODO invalid structure
          end.merge(extract_tags(child)).compact
        end.flatten
      end

      def render_value
        if node_config["render_value"]
          node_config["render_value"].call(block)
        else
          render_children
        end
      end

      def render
        return super unless node

        node.new(block).render
      end

      private

      def structure
        node_config["structure"]
      end

      def extract_tags(child)
        {
          "tag" => child["tag"],
          "css_class" => child["css_class"],
          "meta" => child["meta"],
          "wrappers" => child["wrappers"],
        }.compact
      end

      def build_field(child)
        field = child["field"].to_sym
        value = block[field]

        {
          "type" => "span",
          "value" => value,
          "marks" => Array.wrap(child["marks"]),
        }
      end

      def build_value(child)
        # TODO needs an error if no render value
        value = child["render_value"].call(block)

        {
          "type" => "span",
          "value" => value,
          "marks" => Array.wrap(child["marks"]),
        }
      end

      def build_block(child)
        @blocks << child

        {
          "type" => "block",
          "item" => child[:id],
        }
      end

      def build_blocks(child)
        field = child["field"].to_sym

        parent = {
          "type" => "generic",
          "children" => Array.wrap(block[field]).map { |child_block| build_block(child_block) }
        }
      end
    end
  end
end
