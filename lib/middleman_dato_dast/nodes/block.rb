module MiddlemanDatoDast
  module Nodes
    class Block < Base
      def block_id
        @node["item"]
      end

      def block
        return @block if @block

        @block ||= @blocks.find { |block| block[:id] == block_id }
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
            raise Errors::InvalidBlockStructureType
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

        begin
          node.new(block).render
        rescue NoMethodError => _e
          raise Errors::BlockNodeMissingRenderFunction.new(["block->#{item_type}"])
        end
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
        raise Errors::BlockFieldMissing.new(item_type) unless child["field"]

        field = child["field"].to_sym
        value = block[field]

        {
          "type" => "span",
          "value" => value,
          "marks" => Array.wrap(child["marks"]),
        }
      end

      def build_value(child)
        raise Errors::MissingRenderValueFunction.new(item_type) unless child["render_value"]

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

      def proc_object
        block
      end
    end
  end
end
