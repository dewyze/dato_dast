module DatoDast
  module Nodes
    class Item < Base
      def item_id
        @node["item"]
      end

      def item
        return @item if @item

        @item ||= item_repo.find { |item| item[:id] == item_id }
      end

      def item_type
        item[:item_type]
      end

      def node
        node_config["node"]
      end

      def children
        Array.wrap(structure).map do |child|
          case child["type"]
          when "field"
            build_field(child)
          when "value"
            build_value(child)
          when label
            build_item(item[child["field"].to_sym])
          when label.pluralize
            build_items(child)
          else
            raise DatoDast::Errors::InvalidStructureType.new(error_label)
          end.merge(extract_tags(child)).compact
        end.flatten
      end

      def render_value
        if node_config["render_value"]
          node_config["render_value"].call(item)
        else
          render_children
        end
      end

      def render
        return super unless node

        begin
          node.new(item).render
        rescue NoMethodError => _e
          raise DatoDast::Errors::MissingRenderFunction.new([error_label])
        end
      end

      private

      def label
        @node["type"]
      end

      def error_label
        "#{label}->#{item_type}"
      end

      def item_repo
        raise NotImplementedError
      end

      def node_config
        raise NotImplementedError
      end

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
        raise DatoDast::Errors::FieldMissing.new(error_label) unless child["field"]

        field = child["field"].to_sym
        value = item[field]

        {
          "type" => "span",
          "value" => value,
          "marks" => Array.wrap(child["marks"]),
        }
      end

      def build_value(child)
        raise Errors::MissingRenderValueFunction.new(error_label) unless child["render_value"]

        value = child["render_value"].call(item)

        {
          "type" => "span",
          "value" => value,
          "marks" => Array.wrap(child["marks"]),
        }
      end

      def build_item(child)
        item_repo << child

        {
          "type" => label,
          "item" => child[:id],
        }
      end

      def build_items(child)
        field = child["field"].to_sym

        parent = {
          "type" => "generic",
          "children" => Array.wrap(item[field]).map { |child_item| build_item(child_item) }
        }
      end

      def proc_object
        item
      end
    end
  end
end
